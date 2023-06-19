from typing import List
import datetime as _dt
import pydantic as _pydantic
from pydantic import Field
from typing import Optional


class _UmkmBase(_pydantic.BaseModel):
    nama: str
    alamat: str
    kategori: str
    penghasilan: int
    fotoUmkm: str
    npwp: str
    dokumen: str


class UmkmCreate(_UmkmBase):
    pass


class Umkm(_UmkmBase):
    id: int
    borrower_id: int

    class Config:
        orm_mode = True


class _BorrowerBase(_pydantic.BaseModel):
    nama: str
    email: str
    telp: str
    ktp: str
    saku: int
    status: str


class BorrowerCreate(_BorrowerBase):
    password: str


class Borrower(_BorrowerBase):
    id: int
    umkm: List[Umkm] = []

    class Config:
        orm_mode = True


class BorrowerPatch(_pydantic.BaseModel):
    nama: str = "kosong"
    email: str = "kosong"
    telp: str = "kosong"
    saku: int = -9999
    password: str = "kosong"
    status: str = "kosong"


class _RiwayatBase(_pydantic.BaseModel):
    nominal: int
    status: str


class RiwayatCreate(_RiwayatBase):
    pass


class Riwayat(_RiwayatBase):
    id: int
    borrower_id: int
    created_at: _dt.datetime

    class Config:
        orm_mode = True


class _AjuanBase(_pydantic.BaseModel):
    besar_biaya: int
    tenor_pendanaan: int
    minimal_biaya: int
    opsi_pengembalian: str
    bunga: int
    status: str
    sisa_pengembalian: int


class AjuanCreate(_AjuanBase):
    pass


class Ajuan(_AjuanBase):
    id: int
    borrower_id: int

    tenggat_pengembalian: Optional[_dt.datetime] = Field(None, nullable=True)

    class Config:
        orm_mode = True


class AjuanPatch(_pydantic.BaseModel):
    sisa_pengembalian: int = -9999


class _MarketBase(_pydantic.BaseModel):
    ajuan_id: int
    waktu_acc: _dt.datetime
    dana_terkumpul: int
    tenggat_pendanaan: _dt.datetime
    status: str


class MarketCreate(_MarketBase):
    pass


class Market(_MarketBase):
    id: int

    class Config:
        orm_mode = True


class MarketPatch(_pydantic.BaseModel):
    dana_terkumpul: int = -9999
    status: str = "kosong"


class _LenderBase(_pydantic.BaseModel):
    nama: str
    email: str
    telp: str
    ktp: str
    saku: int
    status: str


class LenderCreate(_LenderBase):
    password: str


class Lender(_LenderBase):
    id: int

    class Config:
        orm_mode = True


class LenderPatch(_pydantic.BaseModel):
    nama: str = "kosong"
    email: str = "kosong"
    telp: str = "kosong"
    saku: int = -9999
    password: str = "kosong"
    status: str = "kosong"


class _RiwayatLenderBase(_pydantic.BaseModel):
    nominal: int
    status: str


class RiwayatLenderCreate(_RiwayatLenderBase):
    pass


class RiwayatLender(_RiwayatLenderBase):
    id: int
    lender_id: int
    created_at: _dt.datetime

    class Config:
        orm_mode = True


class _PendanaanBase(_pydantic.BaseModel):
    total_pinjaman: int
    market_id: int
    status: str


class PendanaanCreate(_PendanaanBase):
    pass


class Pendanaan(_PendanaanBase):
    id: int
    lender_id: int

    class Config:
        orm_mode = True


class _ActivityBorrowerBase(_pydantic.BaseModel):
    borrower_id: int
    keterangan: str
    status: str
    biaya: int


class ActivityBorrowerCreate(_ActivityBorrowerBase):
    pass


class ActivityBorrower(_ActivityBorrowerBase):
    id: int
    created_at: _dt.datetime

    class Config:
        orm_mode = True


class _ActivityLenderBase(_pydantic.BaseModel):
    lender_id: int
    keterangan: str
    status: str
    biaya: int


class ActivityLenderCreate(_ActivityLenderBase):
    pass


class ActivityLender(_ActivityLenderBase):
    id: int
    created_at: _dt.datetime

    class Config:
        orm_mode = True


class _NotifikasiBorrowerBase(_pydantic.BaseModel):
    borrower_id: int
    title: str
    deskripsi: str
    status: str


class NotifikasiBorrowerCreate(_NotifikasiBorrowerBase):
    pass


class NotifikasiBorrower(_NotifikasiBorrowerBase):
    id: int
    created_at: _dt.datetime

    class Config:
        orm_mode = True


class _NotifikasiLenderBase(_pydantic.BaseModel):
    lender_id: int
    title: str
    deskripsi: str
    status: str


class NotifikasiLenderCreate(_NotifikasiLenderBase):
    pass


class NotifikasiLender(_NotifikasiLenderBase):
    id: int
    created_at: _dt.datetime

    class Config:
        orm_mode = True
