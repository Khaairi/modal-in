import sqlalchemy as _sql
import sqlalchemy.orm as _orm
import database as _database
import datetime as _dt


class Borrower(_database.Base):
    __tablename__ = "borrowers"
    id = _sql.Column(_sql.Integer, primary_key=True, index=True)
    nama = _sql.Column(_sql.String)
    email = _sql.Column(_sql.String, unique=True)
    password = _sql.Column(_sql.String)
    telp = _sql.Column(_sql.String)
    ktp = _sql.Column(_sql.String)
    saku = _sql.Column(_sql.Integer)

    umkm = _orm.relationship("Umkm", back_populates="owner")
    riwayat = _orm.relationship("RiwayatBorrower", back_populates="owner")


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
    ajuan = _orm.relationship("Ajuan", back_populates="owner")


class RiwayatBorrower(_database.Base):
    __tablename__ = "riwayatBorrowers"
    id = _sql.Column(_sql.Integer, primary_key=True, index=True)
    borrower_id = _sql.Column(_sql.Integer, _sql.ForeignKey("borrowers.id"))
    nominal = _sql.Column(_sql.Integer)
    status = _sql.Column(_sql.String)
    created_at = _sql.Column(_sql.DateTime, default=_dt.datetime.utcnow)

    owner = _orm.relationship("Borrower", back_populates="riwayat")


class Ajuan(_database.Base):
    __tablename__ = "ajuan"
    id = _sql.Column(_sql.Integer, primary_key=True, index=True)
    umkm_id = _sql.Column(_sql.Integer, _sql.ForeignKey("umkms.id"))
    besar_biaya = _sql.Column(_sql.Integer)
    tenor_pendanaan = _sql.Column(_sql.Integer)
    minimal_biaya = _sql.Column(_sql.Integer)
    opsi_pengembalian = _sql.Column(_sql.String)
    status = _sql.Column(_sql.String, nullable=True)
    tenggat_pengembalian = _sql.Column(_sql.DateTime, nullable=True)
    bunga = _sql.Column(_sql.Integer, nullable=True)

    owner = _orm.relationship("Umkm", back_populates="ajuan")
