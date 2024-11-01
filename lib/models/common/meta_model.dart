class Meta {
    final DateTime? timestamp;

    Meta({
        this.timestamp,
    });

    factory Meta.fromJson(Map<String, dynamic> json) => Meta(
        timestamp: json["timestamp"] == null ? null : DateTime.parse(json["timestamp"]),
    );

    Map<String, dynamic> toJson() => {
        "timestamp": timestamp?.toIso8601String(),
    };
}
