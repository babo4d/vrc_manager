import 'dart:collection';

class VRChatStatus {
  dynamic content;
  late int statusCode;
  late String message;

  VRChatStatus.fromJson(this.content) {
    message = content['success']['message'];
    statusCode = content['success']['status_code'];
  }
}

class VRChatError {
  dynamic content;
  late int statusCode;
  late String message;

  VRChatError.fromJson(this.content) {
    message = content['error']['message'];
    statusCode = content['error']['status_code'];
  }
  VRChatError.fromHtml(String this.content) {
    Match match = RegExp(r'<head><title>([0-9]{3})\s?(.*?)</title></head>').firstMatch(content)!;
    if (match.groupCount == 2) {
      message = match.group(2)!;
      statusCode = int.parse(match.group(1)!);
    } else {
      throw FormatException(message = "Could not decode html", content);
    }
  }
}

class VRChatLogin {
  dynamic content;
  bool verified = false;
  bool requiresTwoFactorAuth = false;

  VRChatLogin.fromJson(this.content) {
    verified = content['verified'] ?? content.containsKey('username');
    if (content.containsKey('requiresTwoFactorAuth')) requiresTwoFactorAuth = true;
  }
}

class VRChatUserSelfOverload extends VRChatUserSelf {
  late List<String> offlineFriends;
  late List<String> onlineFriends;
  late List<String> statusHistory;
  late String steamId;
  late bool twoFactorAuthEnabled;
  late DateTime? twoFactorAuthEnabledDate;

  @override
  VRChatUserSelfOverload.fromJson(content) : super.fromJson(content) {
    offlineFriends = content['offlineFriends'].cast<String>();
    onlineFriends = content['onlineFriends'].cast<String>();
    statusHistory = content['statusHistory'].cast<String>();
    steamId = content['steamId'];
    twoFactorAuthEnabled = content['twoFactorAuthEnabled'];
    twoFactorAuthEnabledDate = content['twoFactorAuthEnabledDate'] == null ? null : DateTime.parse(content['twoFactorAuthEnabledDate']);
  }
}

class VRChatUserSelf extends VRChatUser {
  late int acceptedTOSVersion;
  late DateTime? accountDeletionDate;
  late List<String> activeFriends;
  late String currentAvatar;
  late String currentAvatarAssetUrl;
  late bool emailVerified;
  late List<String> friendGroupNames;
  late String friendKey;
  late bool hasBirthday;
  late bool hasEmail;
  late bool hasLoggedInFromClient;
  late bool hasPendingEmail;
  late String homeLocation;
  late String obfuscatedEmail;
  late String obfuscatedPendingEmail;
  late String oculusId;
  late List<Map<String, String>> pastDisplayNames = [];
  late bool statusFirstTime;
  late Map steamDetails; //default {}
  late bool unsubscribe;

  VRChatUserSelf.fromJson(content) : super.fromJson(content) {
    acceptedTOSVersion = content['acceptedTOSVersion'];
    accountDeletionDate = content['accountDeletionDate'] == null ? null : DateTime.parse(content['accountDeletionDate']);
    activeFriends = content['activeFriends'] == null ? [] : content['activeFriends'].cast<String>();
    currentAvatar = content['currentAvatar'];
    currentAvatarAssetUrl = content['currentAvatarAssetUrl'];
    emailVerified = content['emailVerified'];
    friendGroupNames = content['friendGroupNames'].cast<String>();
    friendKey = content['friendKey'];
    hasBirthday = content['hasBirthday'];
    hasEmail = content['hasEmail'];
    hasLoggedInFromClient = content['hasLoggedInFromClient'];
    hasPendingEmail = content['hasPendingEmail'];
    homeLocation = content['homeLocation'];
    obfuscatedEmail = content['obfuscatedEmail'];
    obfuscatedPendingEmail = content['obfuscatedPendingEmail'];
    oculusId = content['oculusId'];
    pastDisplayNames = content['pastDisplayNames'].cast<Map<String, String>>();
    statusFirstTime = content['statusFirstTime'];
    steamDetails = content['steamDetails'];
    unsubscribe = content['unsubscribe'];
  }
}

class VRChatFriendsList extends ListBase<VRChatFriends> {
  dynamic content;
  late List<VRChatFriends> _list = [];

  @override
  set length(int newLength) => _list.length = newLength;

  @override
  int get length => _list.length;

  @override
  VRChatFriends operator [](int index) => _list[index];

  @override
  operator []=(int index, VRChatFriends value) => _list[index] = value;

  VRChatFriendsList.fromJson(content) {
    _list = [for (dynamic u in content) VRChatFriends.fromJson(u)];
  }
}

class VRChatFriends extends VRChatUser {
  late String friendKey;
  late String? travelingToInstance;
  late String? travelingToLocation;
  late String? travelingToWorld;
  late String worldId;

  VRChatFriends.fromJson(content) : super.fromJson(content) {
    friendKey = content['friendKey'];
    travelingToInstance = content['travelingToInstance'];
    travelingToLocation = content['travelingToLocation'];
    travelingToWorld = content['travelingToWorld'];
    worldId = content['worldId'] == "" ? location : content['location'] ?? location;
  }
}

class VRChatUserList extends ListBase<VRChatUser> {
  dynamic content;
  late List<VRChatUser> _list = [];

  @override
  set length(int newLength) => _list.length = newLength;

  @override
  int get length => _list.length;

  @override
  VRChatUser operator [](int index) => _list[index];

  @override
  operator []=(int index, VRChatUser value) => _list[index] = value;

  VRChatUserList.fromJson(content) {
    _list = [for (dynamic u in content) VRChatUser.fromJson(u)];
  }
}

class VRChatUser {
  dynamic content;

  late String? bio;
  late String currentAvatarImageUrl;
  late String currentAvatarThumbnailImageUrl;
  late String developerType;
  late String displayName;
  late String? fallbackAvatar;
  late String id;
  late bool isFriend;
  late String lastPlatform;
  late String? profilePicOverride;
  late String status;
  late String? statusDescription;
  late List<String> tags;
  late String userIcon;
  late String username;
  late String location;

  late bool allowAvatarCopying;
  late List<String> bioLinks;
  late DateTime? dateJoined;
  late String? friendRequestStatus;
  late String? instanceId;
  late String? lastActivity;
  late DateTime? lastLogin;
  late String? note;
  late String? state;

  VRChatUser.fromJson(this.content) {
    bio = content['bio'] == "" ? null : content['bio'];
    currentAvatarImageUrl = content['currentAvatarImageUrl'];
    currentAvatarThumbnailImageUrl = content['currentAvatarThumbnailImageUrl'];
    developerType = content['developerType'];
    displayName = content['displayName'];
    fallbackAvatar = content['fallbackAvatar'];
    id = content['id'];
    isFriend = content['isFriend'];
    lastPlatform = content['last_platform'];
    profilePicOverride = content['profilePicOverride'] == "" ? null : content['profilePicOverride'];
    status = content['status'];
    statusDescription = content['statusDescription'] == "" ? null : content['statusDescription'];
    tags = content['tags'].cast<String>();
    userIcon = content['userIcon'];
    username = content['username'];
    location = content['location'] == "" ? "offline" : content['location'] ?? "offline";

    allowAvatarCopying = content['allowAvatarCopying'] ?? false;
    bioLinks = (content['bioLinks'] ?? []).cast<String>();
    dateJoined = content['date_joined'] == null ? null : DateTime.parse(content['date_joined']);
    friendRequestStatus = content['friendRequestStatus'];
    instanceId = content['instanceId'];
    lastActivity = content['last_activity'];
    lastLogin = content['last_login'] == null || content['last_login'] == "" ? null : DateTime.parse(content['last_login']);
    state = content['state'];
    note = content['note'] == "" ? null : content['note'];
  }
}

class VRChatUserNotes {
  dynamic content;

  late DateTime createdAt;
  late String id;
  late String? note;
  late String targetUserId;
  late String userId;

  VRChatUserNotes.fromJson(this.content) {
    if (content is String) return;
    createdAt = DateTime.parse(content['createdAt']);
    id = content['id'];
    note = content['note'] == "" ? null : content['note'];
    targetUserId = content['targetUserId'];
    userId = content['userId'];
  }
}

class VRChatfriendStatus {
  dynamic content;

  late bool incomingRequest;
  late bool isFriend;
  late bool outgoingRequest;

  VRChatfriendStatus.fromJson(this.content) {
    incomingRequest = content['incomingRequest'];
    isFriend = content['isFriend'];
    outgoingRequest = content['outgoingRequest'];
  }
}

class VRChatWorldList extends ListBase<VRChatWorld> {
  dynamic content;
  late List<VRChatWorld> _list = [];

  @override
  set length(int newLength) => _list.length = newLength;

  @override
  int get length => _list.length;

  @override
  VRChatWorld operator [](int index) => _list[index];

  @override
  operator []=(int index, VRChatWorld value) => _list[index] = value;

  VRChatWorldList.fromJson(content) {
    _list = [for (dynamic u in content) VRChatWorld.fromJson(u)];
  }
}

class VRChatWorld {
  dynamic content;

  late String assetUrl;
  late String authorId;
  late String authorName;
  late int capacity;
  late DateTime createdAt;
  late String? description;
  late int favorites;
  late bool featured;
  late int heat;
  late String id;
  late String imageUrl;
  late List<Map<String, int>> instances = [];
  late DateTime? labsPublicationDate;
  late String name;
  late String namespace;
  late int occupants;
  late String organization;
  late int popularity;
  late String? previewYoutubeId;
  late int privateOccupants;
  late int publicOccupants;
  late DateTime? publicationDate;
  late String releaseStatus;
  late List<String> tags;
  late String thumbnailImageUrl;
  late List<UnityPackages> unityPackages = [];
  late DateTime updatedAt;
  late int version;
  late int visits;

  VRChatWorld.fromJson(this.content) {
    assetUrl = content['assetUrl'];
    authorId = content['authorId'];
    authorName = content['authorName'];
    capacity = content['capacity'];
    createdAt = DateTime.parse(content['created_at']);
    description = content['description'] == "" ? null : content['description'];
    favorites = content['favorites'] ?? 0;
    featured = content['featured'] ?? false;
    heat = content['heat'];
    id = content['id'];
    imageUrl = content['imageUrl'];
    instances = content['instances'].cast<Map<String, int>>();
    labsPublicationDate = content['labsPublicationDate'] == "none" ? null : DateTime.parse(content['labsPublicationDate']);
    name = content['name'];
    namespace = content['namespace'];
    occupants = content['occupants'];
    organization = content['organization'];
    popularity = content['popularity'];
    previewYoutubeId = content['previewYoutubeId'] == "" ? null : content['previewYoutubeId'];
    privateOccupants = content['privateOccupants'];
    publicationDate = content['publicationDate'] == "none" ? null : DateTime.parse(content['publicationDate']);
    publicOccupants = content['publicOccupants'];
    releaseStatus = content['releaseStatus'];
    tags = content['tags'].cast<String>();
    thumbnailImageUrl = content['thumbnailImageUrl'];
    for (dynamic unitypackage in content['unityPackages']) {
      unityPackages.add(UnityPackages.fromJson(unitypackage));
    }
    updatedAt = DateTime.parse(content['updated_at']);
    version = content['version'];
    visits = content['visits'];
  }
  VRChatLimitedWorld toLimited() {
    return VRChatLimitedWorld.fromJson(content);
  }
}

class VRChatLimitedWorldList extends ListBase<VRChatLimitedWorld> {
  dynamic content;
  late List<VRChatLimitedWorld> _list = [];

  @override
  set length(int newLength) => _list.length = newLength;

  @override
  int get length => _list.length;

  @override
  VRChatLimitedWorld operator [](int index) => _list[index];

  @override
  operator []=(int index, VRChatLimitedWorld value) => _list[index] = value;

  VRChatLimitedWorldList.fromJson(content) {
    _list = [for (dynamic u in content) VRChatLimitedWorld.fromJson(u)];
  }
}

class VRChatLimitedWorld {
  dynamic content;

  late String authorId;
  late String authorName;
  late int capacity;
  late DateTime createdAt;
  late int favorites;
  late int heat;
  late String id;
  late String imageUrl;
  late String labsPublicationDate;
  late String name;
  late int occupants;
  late String organization;
  late int popularity;
  late String publicationDate;
  late String releaseStatus;
  late List<String> tags;
  late String thumbnailImageUrl;
  late List<LimitedUnityPackages> unityPackages = [];
  late DateTime updatedAt;

  VRChatLimitedWorld.fromJson(this.content) {
    authorId = content['authorId'];
    authorName = content['authorName'];
    capacity = content['capacity'];
    createdAt = DateTime.parse(content['created_at']);
    favorites = content['favorites'];
    heat = content['heat'];
    id = content['id'];
    imageUrl = content['imageUrl'];
    labsPublicationDate = content['labsPublicationDate'];
    name = content['name'];
    occupants = content['occupants'];
    organization = content['organization'];
    popularity = content['popularity'];
    publicationDate = content['publicationDate'];
    releaseStatus = content['releaseStatus'];
    tags = content['tags'].cast<String>();
    thumbnailImageUrl = content['thumbnailImageUrl'];
    for (dynamic unityPackage in content['unityPackages']) {
      unityPackages.add(LimitedUnityPackages.fromJson(unityPackage));
    }
    updatedAt = DateTime.parse(content['updated_at']);
  }
}

class VRChatInstance {
  dynamic content;

  late bool active;
  late bool canRequestInvite;
  late int capacity;
  late String clientNumber; //default unknown
  late bool full;
  late String id;
  late String instanceId;
  late String location;
  late int nUsers;
  late String name;
  late String? ownerId;
  late bool permanent;
  late String photonRegion;
  late VRChatPlatforms platforms;
  late String region;
  late String? secureName;
  late String? shortName;
  late bool strict;
  late List<String> tags;
  late String type;
  late String worldId;
  late String? hidden;
  late String? friends;
  late String? private;

  VRChatInstance.fromJson(this.content) {
    active = content['active'];
    canRequestInvite = content['canRequestInvite'];
    capacity = content['capacity'];
    clientNumber = content['clientNumber'];
    full = content['full'];
    id = content['id'];
    instanceId = content['instanceId'];
    location = content['location'];
    nUsers = content['n_users'];
    name = content['name'];
    ownerId = content['ownerId'];
    permanent = content['permanent'];
    photonRegion = content['photonRegion'];
    platforms = VRChatPlatforms.fromJson(content['platforms']);
    region = content['region'];
    secureName = content['secureName'];
    shortName = content['shortName'];
    strict = content['strict'] ?? false;
    tags = content['tags'].cast<String>();
    type = content['type'];
    worldId = content['worldId'];
    hidden = content['hidden'];
    friends = content['friends'];
    private = content['private'];
  }
}

class VRChatSecureName {
  dynamic content;

  late String? shortName;
  late String? secureName;
  VRChatSecureName.fromJson(this.content) {
    shortName = content['shortName'];
    secureName = content['secureName'];
  }
}

class VRChatPlatforms {
  dynamic content;

  late int android;
  late int standalonewindows;

  VRChatPlatforms.fromJson(this.content) {
    android = content['android'];
    standalonewindows = content['standalonewindows'];
  }
}

class VRChatFavoriteWorldList extends ListBase<VRChatFavoriteWorld> {
  dynamic content;
  late List<VRChatFavoriteWorld> _list = [];

  @override
  set length(int newLength) => _list.length = newLength;

  @override
  int get length => _list.length;

  @override
  VRChatFavoriteWorld operator [](int index) => _list[index];

  @override
  operator []=(int index, VRChatFavoriteWorld value) => _list[index] = value;

  VRChatFavoriteWorldList.fromJson(content) {
    _list = [for (dynamic u in content) VRChatFavoriteWorld.fromJson(u)];
  }
}

class VRChatFavoriteWorld {
  dynamic content;

  late String authorId;
  late String authorName;
  late int capacity;
  late DateTime createdAt;
  late int favorites;
  late int heat;
  late String id;
  late String imageUrl;
  late DateTime? labsPublicationDate;
  late String name;
  late int occupants;
  late String organization;
  late int popularity;
  late DateTime? publicationDate;
  late String releaseStatus;
  late List<String> tags;
  late String thumbnailImageUrl;
  late List<LimitedUnityPackages> unityPackages = [];
  late DateTime updatedAt;
  late String favoriteId;
  late String favoriteGroup;

  VRChatFavoriteWorld.fromJson(this.content) {
    authorId = content['authorId'];
    authorName = content['authorName'];
    capacity = content['capacity'];
    createdAt = DateTime.parse(content['created_at']);
    favorites = content['favorites'];
    heat = content['heat'];
    id = content['id'];
    imageUrl = content['imageUrl'];
    labsPublicationDate = content['labsPublicationDate'] == "none" ? null : DateTime.parse(content['labsPublicationDate']);
    name = content['name'];
    occupants = content['occupants'];
    organization = content['organization'];
    popularity = content['popularity'];
    publicationDate = content['publicationDate'] == "none" ? null : DateTime.parse(content['publicationDate']);
    releaseStatus = content['releaseStatus'];
    tags = content['tags'].cast<String>();
    thumbnailImageUrl = content['thumbnailImageUrl'];
    for (dynamic unityPackage in content['unityPackages']) {
      unityPackages.add(LimitedUnityPackages.fromJson(unityPackage));
    }
    updatedAt = DateTime.parse(content['updated_at']);
    favoriteId = content['favoriteId'];
    favoriteGroup = content['favoriteGroup'];
  }

  VRChatFavoriteWorld.fromFavorite(VRChatWorld world, VRChatFavorite favorite, String favoriteGroup) {
    if (world.id != favorite.favoriteId) throw ArgumentError();
    authorId = world.authorId;
    authorName = world.authorName;
    capacity = world.capacity;
    createdAt = world.createdAt;
    favorites = world.favorites;
    heat = world.heat;
    id = world.id;
    imageUrl = world.imageUrl;
    labsPublicationDate = world.labsPublicationDate;
    name = world.name;
    occupants = world.occupants;
    organization = world.organization;
    popularity = world.popularity;
    publicationDate = world.publicationDate!;
    releaseStatus = world.releaseStatus;
    tags = world.tags;
    thumbnailImageUrl = world.thumbnailImageUrl;
    for (UnityPackages unityPackage in world.unityPackages) {
      unityPackages.add(LimitedUnityPackages.fromUnityPackages(unityPackage));
    }
    updatedAt = world.updatedAt;
    favoriteId = favorite.id;
    favoriteGroup = favoriteGroup;
  }
}

class VRChatFavoriteGroupList extends ListBase<VRChatFavoriteGroup> {
  dynamic content;
  late List<VRChatFavoriteGroup> _list = [];

  @override
  set length(int newLength) => _list.length = newLength;

  @override
  int get length => _list.length;

  @override
  VRChatFavoriteGroup operator [](int index) => _list[index];

  @override
  operator []=(int index, VRChatFavoriteGroup value) => _list[index] = value;

  VRChatFavoriteGroupList.fromJson(content) {
    _list = [for (dynamic u in content) VRChatFavoriteGroup.fromJson(u)];
  }
}

class VRChatFavoriteGroup {
  dynamic content;

  late String ownerDisplayName;
  late String id;
  late String name;
  late String displayName;
  late String ownerId;
  late List<Map<String, int>> tags;
  late String type;
  late String visibility;

  VRChatFavoriteGroup.fromJson(this.content) {
    id = content['id'];
    ownerId = content['ownerId'];
    ownerDisplayName = content['ownerDisplayName'];
    name = content['name'];
    displayName = content['displayName'];
    type = content['type'];
    visibility = content['visibility'];
    tags = content['tags'].cast<Map<String, int>>();
  }
}

class VRChatNotificationsList extends ListBase<VRChatNotifications> {
  dynamic content;
  late List<VRChatNotifications> _list = [];

  @override
  set length(int newLength) => _list.length = newLength;

  @override
  int get length => _list.length;

  @override
  VRChatNotifications operator [](int index) => _list[index];

  @override
  operator []=(int index, VRChatNotifications value) => _list[index] = value;

  VRChatNotificationsList.fromJson(content) {
    _list = [for (dynamic u in content) VRChatNotifications.fromJson(u)];
  }
}

class VRChatNotifications {
  dynamic content;

  late DateTime createdAt;
  late String details;
  late String id;
  late String message;
  late bool seen;
  late String senderUserId;
  late String senderUsername;
  late String type;

  VRChatNotifications.fromJson(this.content) {
    createdAt = DateTime.parse(content['created_at']);
    details = content['details'];
    id = content['id'];
    message = content['message'];
    seen = content['seen'];
    senderUserId = content['senderUserId'];
    senderUsername = content['senderUsername'];
    type = content['type'];
  }
}

class VRChatNotificationsInvite {
  dynamic content;

  late DateTime createdAt;
  late Map<String, String> details;
  late String id;
  late String message;
  late String receiverUserId;
  late String senderUserId;
  late String senderUsername;
  late String type;

  VRChatNotificationsInvite.fromJson(this.content) {
    createdAt = DateTime.parse(content['created_at']);
    details = content['details'].cast<String, String>();
    id = content['id'];
    message = content['message'];
    receiverUserId = content['message'];
    senderUserId = content['senderUserId'];
    senderUsername = content['senderUsername'];
    type = content['type'];
  }
}

class VRChatAcceptFriendRequestByUid {
  dynamic content;

  late String details;
  late String message;
  late bool seen;
  late String type;

  VRChatAcceptFriendRequestByUid.fromJson(this.content) {
    details = content['details'];
    message = content['message'];
    seen = content['seen'];
    type = content['type'];
  }
}

class VRChatFavorite {
  dynamic content;

  late String favoriteId;
  late String id;
  late List<String> tags;
  late String type;

  VRChatFavorite.fromJson(this.content) {
    favoriteId = content['favoriteId'];
    id = content['id'];
    tags = content['tags'].cast<String>();
    type = content['type'];
  }
}

class UnityPackages extends LimitedUnityPackages {
  late String assetUrl;
  late Map? assetUrlObject; //default {}
  late int assetVersion;
  late DateTime? createdAt;
  late String id;
  late String pluginUrl;
  late Map? pluginUrlObject; //default {}
  late int unitySortNumber;

  UnityPackages.fromJson(content) : super.fromJson(content) {
    assetUrl = content['assetUrl'];
    assetUrlObject = content['assetUrlObject'];
    assetVersion = content['assetVersion'];
    createdAt = content['created_at'] == null ? null : DateTime.parse(content['created_at']);
    id = content['id'];
    pluginUrl = content['pluginUrl'];
    pluginUrlObject = content['pluginUrlObject'];
    unitySortNumber = content['unitySortNumber'];
  }
}

class LimitedUnityPackages {
  dynamic content;

  late String unityVersion;
  late String platform;

  LimitedUnityPackages.fromJson(this.content) {
    unityVersion = content['unityVersion'];
    platform = content['platform'];
  }

  LimitedUnityPackages.fromUnityPackages(UnityPackages unityPackages) {
    unityVersion = unityPackages.unityVersion;
    platform = unityPackages.platform;
  }
}
