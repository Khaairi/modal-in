import sqlalchemy as _sql
import sqlalchemy.orm as _orm
import database as _database
import datetime as _dt
import passlib.hash as _hash


class Borrower(_database.Base):
    __tablename__ = "borrowers"
    id = _sql.Column(_sql.Integer, primary_key=True, index=True)
    nama = _sql.Column(_sql.String)
    email = _sql.Column(_sql.String, unique=True)
    password = _sql.Column(_sql.String)
    telp = _sql.Column(_sql.String)
    ktp = _sql.Column(_sql.String)
    saku = _sql.Column(_sql.Integer)
    status = _sql.Column(_sql.String)

    umkm = _orm.relationship("Umkm", back_populates="owner")
    riwayat = _orm.relationship("RiwayatBorrower", back_populates="owner")
    ajuan = _orm.relationship("Ajuan", back_populates="owner")
    activity = _orm.relationship("ActivityBorrower", back_populates="owner")
    notifikasi = _orm.relationship("NotifikasiBorrower", back_populates="owner")

    def verify_password(self, passwords: str):
        return _hash.bcrypt.verify(passwords, self.password)


class Umkm(_database.Base):
    __tablename__ = "umkms"
    id = _sql.Column(_sql.Integer, primary_key=True, index=True)
    borrower_id = _sql.Column(_sql.Integer, _sql.ForeignKey("borrowers.id"))
    nama = _sql.Column(_sql.String)
    alamat = _sql.Column(_sql.String)
    kategori = _sql.Column(_sql.String)
    penghasilan = _sql.Column(_sql.Integer)
    fotoUmkm = _sql.Column(_sql.String)
    npwp = _sql.Column(_sql.String)
    dokumen = _sql.Column(_sql.String)

    owner = _orm.relationship("Borrower", back_populates="umkm")


class RiwayatBorrower(_database.Base):
    __tablename__ = "riwayatBorrowers"
    id = _sql.Column(_sql.Integer, primary_key=True, index=True)
    borrower_id = _sql.Column(_sql.Integer, _sql.ForeignKey("borrowers.id"))
    nominal = _sql.Column(_sql.Integer)
    status = _sql.Column(_sql.String)
    created_at = _sql.Column(_sql.DateTime, default=_dt.datetime.now)

    owner = _orm.relationship("Borrower", back_populates="riwayat")


class Ajuan(_database.Base):
    __tablename__ = "ajuan"
    id = _sql.Column(_sql.Integer, primary_key=True, index=True)
    borrower_id = _sql.Column(_sql.Integer, _sql.ForeignKey("borrowers.id"))
    besar_biaya = _sql.Column(_sql.Integer)
    tenor_pendanaan = _sql.Column(_sql.Integer)
    minimal_biaya = _sql.Column(_sql.Integer)
    opsi_pengembalian = _sql.Column(_sql.String)
    status = _sql.Column(_sql.String)
    tenggat_pengembalian = _sql.Column(_sql.DateTime)
    bunga = _sql.Column(_sql.Integer)
    sisa_pengembalian = _sql.Column(_sql.Integer)

    owner = _orm.relationship("Borrower", back_populates="ajuan")
    market = _orm.relationship("Market", back_populates="owner")


class Market(_database.Base):
    __tablename__ = "markets"
    id = _sql.Column(_sql.Integer, primary_key=True, index=True)
    ajuan_id = _sql.Column(_sql.Integer, _sql.ForeignKey("ajuan.id"))
    waktu_acc = _sql.Column(_sql.DateTime, default=_dt.datetime.now)
    dana_terkumpul = _sql.Column(_sql.Integer)
    tenggat_pendanaan = _sql.Column(_sql.DateTime)
    status = _sql.Column(_sql.String)

    owner = _orm.relationship("Ajuan", back_populates="market")
    pendanaan = _orm.relationship("Pendanaan", back_populates="owner")


class Lender(_database.Base):
    __tablename__ = "lenders"
    id = _sql.Column(_sql.Integer, primary_key=True, index=True)
    nama = _sql.Column(_sql.String)
    email = _sql.Column(_sql.String, unique=True)
    password = _sql.Column(_sql.String)
    telp = _sql.Column(_sql.String)
    ktp = _sql.Column(_sql.String)
    saku = _sql.Column(_sql.Integer)
    status = _sql.Column(_sql.String)

    riwayat = _orm.relationship("RiwayatLender", back_populates="owner")
    pendanaan = _orm.relationship("Pendanaan", back_populates="owners")
    activity = _orm.relationship("ActivityLender", back_populates="owner")
    notifikasi = _orm.relationship("NotifikasiLender", back_populates="owner")

    def verify_password(self, passwords: str):
        return _hash.bcrypt.verify(passwords, self.password)


class RiwayatLender(_database.Base):
    __tablename__ = "riwayatLenders"
    id = _sql.Column(_sql.Integer, primary_key=True, index=True)
    lender_id = _sql.Column(_sql.Integer, _sql.ForeignKey("lenders.id"))
    nominal = _sql.Column(_sql.Integer)
    status = _sql.Column(_sql.String)
    created_at = _sql.Column(_sql.DateTime, default=_dt.datetime.now)

    owner = _orm.relationship("Lender", back_populates="riwayat")


class Pendanaan(_database.Base):
    __tablename__ = "pendanaan"
    id = _sql.Column(_sql.Integer, primary_key=True, index=True)
    lender_id = _sql.Column(_sql.Integer, _sql.ForeignKey("lenders.id"))
    market_id = _sql.Column(_sql.Integer, _sql.ForeignKey("markets.id"))
    total_pinjaman = _sql.Column(_sql.Integer)
    status = _sql.Column(_sql.String)

    owners = _orm.relationship("Lender", back_populates="pendanaan")
    owner = _orm.relationship("Market", back_populates="pendanaan")


class ActivityBorrower(_database.Base):
    __tablename__ = "activityBorrower"
    id = _sql.Column(_sql.Integer, primary_key=True, index=True)
    borrower_id = _sql.Column(_sql.Integer, _sql.ForeignKey("borrowers.id"))
    keterangan = _sql.Column(_sql.String)
    status = _sql.Column(_sql.String)
    biaya = _sql.Column(_sql.Integer)
    created_at = _sql.Column(_sql.DateTime, default=_dt.datetime.now)

    owner = _orm.relationship("Borrower", back_populates="activity")


class ActivityLender(_database.Base):
    __tablename__ = "activityLender"
    id = _sql.Column(_sql.Integer, primary_key=True, index=True)
    lender_id = _sql.Column(_sql.Integer, _sql.ForeignKey("lenders.id"))
    keterangan = _sql.Column(_sql.String)
    status = _sql.Column(_sql.String)
    biaya = _sql.Column(_sql.Integer)
    created_at = _sql.Column(_sql.DateTime, default=_dt.datetime.now)

    owner = _orm.relationship("Lender", back_populates="activity")


class NotifikasiBorrower(_database.Base):
    __tablename__ = "notifikasiBorrower"
    id = _sql.Column(_sql.Integer, primary_key=True, index=True)
    borrower_id = _sql.Column(_sql.Integer, _sql.ForeignKey("borrowers.id"))
    title = _sql.Column(_sql.String)
    deskripsi = _sql.Column(_sql.String)
    created_at = _sql.Column(_sql.DateTime, default=_dt.datetime.now)
    status = _sql.Column(_sql.String)

    owner = _orm.relationship("Borrower", back_populates="notifikasi")


class NotifikasiLender(_database.Base):
    __tablename__ = "notifikasiLender"
    id = _sql.Column(_sql.Integer, primary_key=True, index=True)
    lender_id = _sql.Column(_sql.Integer, _sql.ForeignKey("lenders.id"))
    title = _sql.Column(_sql.String)
    deskripsi = _sql.Column(_sql.String)
    created_at = _sql.Column(_sql.DateTime, default=_dt.datetime.now)
    status = _sql.Column(_sql.String)

    owner = _orm.relationship("Lender", back_populates="notifikasi")
