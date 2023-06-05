import database as _database, models as _models, schemas as _schemas
import sqlalchemy.orm as _orm


def create_database():
    return _database.Base.metadata.create_all(bind=_database.engine)


def get_db():
    db = _database.SessionLocal()
    try:
        yield db
    finally:
        db.close()


def get_borrower_by_email(db: _orm.Session, email: str):
    return db.query(_models.Borrower).filter(_models.Borrower.email == email).first()


def get_borrower_by_id(db: _orm.Session, borrower_id: int):
    return db.query(_models.Borrower).filter(_models.Borrower.id == borrower_id).first()


def create_borrower(db: _orm.Session, borrower: _schemas.BorrowerCreate):
    db_borrower = _models.Borrower(
        nama=borrower.nama,
        email=borrower.email,
        password=borrower.password,
        telp=borrower.telp,
        ktp=borrower.ktp,
        saku=borrower.saku,
    )
    db.add(db_borrower)
    db.commit()
    db.refresh(db_borrower)
    return db_borrower


def get_borrower_login(db: _orm.Session, borrower: _schemas.BorrowerLogin):
    db_borrower = get_borrower_by_email(db=db, email=borrower.email)
    if db_borrower is not None:
        if db_borrower.password != borrower.password:
            db_borrower = "password salah"

    return db_borrower


# def get_borrower_login(db: _orm.Session, email: str, password: str):
#     db_borrower = get_borrower_by_email(db=db, email=email)
#     if db_borrower is not None:
#         if db_borrower.password != password:
#             db_borrower = "password salah"
#     return db_borrower


def delete_borrower(db: _orm.Session, borrower_id: int):
    db.query(_models.Borrower).filter(_models.Borrower.id == borrower_id).delete()
    db.commit()


def create_umkm(db: _orm.Session, umkm: _schemas.UmkmCreate):
    db_umkm = _models.Umkm(
        nama=umkm.nama,
        alamat=umkm.alamat,
        kategori=umkm.kategori,
        penghasilan=umkm.penghasilan,
        fotoUmkm=umkm.fotoUmkm,
        npwp=umkm.npwp,
        dokumen=umkm.dokumen,
        borrower_id=umkm.borrower_id,
    )
    db.add(db_umkm)
    db.commit()
    db.refresh(db_umkm)
    return db_umkm


def delete_umkm(db: _orm.Session, umkm_id: int):
    db.query(_models.Umkm).filter(_models.Umkm.id == umkm_id).delete()
    db.commit()


def create_riwayat(db: _orm.Session, riwayat: _schemas.RiwayatCreate):
    db_riwayat = _models.RiwayatBorrower(
        borrower_id=riwayat.borrower_id,
        nominal=riwayat.nominal,
        status=riwayat.status,
    )
    db.add(db_riwayat)
    db.commit()
    db.refresh(db_riwayat)
    return db_riwayat

def create_ajuan(db: _orm.Session, ajuan: _schemas.AjuanCreate):
    db_ajuan = _models.Ajuan(
        besar_biaya = ajuan.besar_biaya,
        tenor_pendanaan = ajuan.tenor_pendanaan,
        minimal_biaya = ajuan.minimal_biaya,
        opsi_pengembalian = ajuan.opsi_pengembalian,
        umkm_id = ajuan.umkm_id,
    )
    db.add(db_ajuan)
    db.commit()
    db.refresh(db_ajuan)
    return db_ajuan
