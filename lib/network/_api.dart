class API {
  String? key;
  int? maxResults;
  String? order;
  String? safeSearch;
  String? type;
  String? videoDuration;
  String? nextPageToken;
  String? prevPageToken;
  String? query;
  String? channelId;
  Map<String, dynamic>? options;
  String? regionCode;
  static String baseURL = 'www.googleapis.com';

  API({this.key, this.type, this.maxResults, this.query});

  Uri trendingUri({required String regionCode}) {
    this.regionCode = regionCode;
    final options = getTrendingOption(regionCode);
    Uri url = Uri.https(baseURL, "youtube/v3/videos", options);
    return url;
  }

  Uri searchUri(
      String query, {
        String? type,
        String? regionCode,
        required String videoDuration,
        required String order,
      }) {
    this.query = query;
    this.type = type ?? this.type;
    this.channelId = null;
    final options = {
      "q": "${this.query}",
      "part": "snippet",
      "maxResults": "${this.maxResults}",
      "key": "${this.key}",
      "type": "${this.type}",
      "order": order,
      "videoDuration": videoDuration,
    };
    if (regionCode != null) options['regionCode'] = regionCode;
    print(options);
    Uri url = Uri.https(baseURL, "youtube/v3/search", options);
    return url;
  }

  Uri channelUri(String channelId, String? order) {
    this.order = order ?? 'date';
    this.channelId = channelId;
    final options = getChannelOption(channelId, this.order!);
    Uri url = Uri.https(baseURL, "youtube/v3/search", options);
    return url;
  }

  Uri playlistUri(String channelId, String? order) {
    this.order = order ?? 'date';
    this.channelId = channelId;
    var options = getChannelOption(channelId, this.order!);
    Uri url = Uri.https(baseURL, "youtube/v3/playlists", options);
    return url;
  }

  Uri videoUri(List<String> videoId) {
    int length = videoId.length;
    String videoIds = videoId.join(',');
    var options = getVideoOption(videoIds, length);
    Uri url = Uri.https(baseURL, "youtube/v3/videos", options);
    return url;
  }

//  For Getting Getting Next Page
  Uri nextPageUri(bool getTrending) {
    Uri url;
    if (getTrending) {
      var options = getTrendingPageOption("pageToken", nextPageToken!);
      url = Uri.https(baseURL, "youtube/v3/videos", options);
    } else {
      var options = channelId == null
          ? getOptions("pageToken", nextPageToken!)
          : getChannelPageOption(channelId!, "pageToken", nextPageToken!);
      url = Uri.https(baseURL, "youtube/v3/search", options);
    }
    return url;
  }

//  For Getting Getting Previous Page
  Uri prevPageUri(bool getTrending) {
    Uri url;
    if (getTrending) {
      var options = getTrendingPageOption("pageToken", prevPageToken!);
      url = Uri.https(baseURL, "youtube/v3/videos", options);
    } else {
      final options = channelId == null
          ? getOptions("pageToken", prevPageToken!)
          : getChannelPageOption(channelId!, "pageToken", prevPageToken!);
      url = Uri.https(baseURL, "youtube/v3/search", options);
    }
    return url;
  }

  Map<String, dynamic> getTrendingOption(String regionCode) {
    this.regionCode = regionCode;
    Map<String, dynamic> options = {
      "part": "snippet",
      "chart": "mostPopular",
      "maxResults": "$maxResults",
      "regionCode": "${this.regionCode}",
      "key": "${key}",
    };
    return options;
  }

  Map<String, dynamic> getTrendingPageOption(String key, String value) {
    Map<String, dynamic> options = {
      key: value,
      "part": "snippet",
      "chart": "mostPopular",
      "maxResults": "$maxResults",
      "regionCode": "${regionCode}",
      "key": "${this.key}",
    };
    return options;
  }

  Map<String, dynamic> getOptions(String key, String value) {
    Map<String, dynamic> options = {
      key: value,
      "q": "$query",
      "part": "snippet",
      "maxResults": "$maxResults",
      "key": "${this.key}",
      "type": "$type"
    };
    return options;
  }

  Map<String, dynamic> getOption() {
    Map<String, dynamic> options = {
      "q": "$query",
      "part": "snippet",
      "maxResults": "$maxResults",
      "key": "$key",
      "type": "$type"
    };
    return options;
  }

  Map<String, dynamic> getChannelOption(String channelId, String order) {
    Map<String, dynamic> options = {
      'channelId': channelId,
      "part": "snippet",
      'order': this.order,
      "maxResults": "$maxResults",
      "key": "$key",
    };
    return options;
  }

  Map<String, dynamic> getChannelPageOption(
      String channelId, String key, String value) {
    Map<String, dynamic> options = {
      key: value,
      'channelId': channelId,
      "part": "snippet",
      "maxResults": "$maxResults",
      "key": "${this.key}",
    };
    return options;
  }

  Map<String, dynamic> getVideoOption(String videoIds, int length) {
    Map<String, dynamic> options = {
      "part": "contentDetails",
      "id": videoIds,
      "maxResults": "$length",
      "key": "$key",
    };
    return options;
  }

  void setNextPageToken(String token) => nextPageToken = token;
  void setPrevPageToken(String token) => prevPageToken = token;
}
