class UserProfile {
  const UserProfile({
    required this.name,
    required this.email,
    this.avatarPath,
    this.gender,
    this.birthDate,
    this.major,
    this.batch,
    this.phone,
  });

  final String name;
  final String email;

  /// Path aset lokal untuk foto avatar.
  /// Jika null, sistem menampilkan avatar default berbasis ikon.
  final String? avatarPath;

  /// Jenis kelamin: "Perempuan" | "Laki Laki"
  final String? gender;

  /// Tanggal lahir
  final DateTime? birthDate;

  /// Program studi / Jurusan
  final String? major;

  /// Tahun angkatan (mis. "2022")
  final String? batch;

  /// Nomor telepon
  final String? phone;

  UserProfile copyWith({
    String? name,
    String? email,
    String? avatarPath,
    String? gender,
    DateTime? birthDate,
    String? major,
    String? batch,
    String? phone,
  }) {
    return UserProfile(
      name: name ?? this.name,
      email: email ?? this.email,
      avatarPath: avatarPath ?? this.avatarPath,
      gender: gender ?? this.gender,
      birthDate: birthDate ?? this.birthDate,
      major: major ?? this.major,
      batch: batch ?? this.batch,
      phone: phone ?? this.phone,
    );
  }
}
