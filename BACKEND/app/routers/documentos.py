from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session
from typing import List
from app import schemas, models
from app.database import get_db

router = APIRouter()

@router.post("/", response_model=schemas.Documento)
def create_documento(documento: schemas.DocumentoCreate, db: Session = Depends(get_db)):
    db_documento = models.Documento(**documento.dict())
    db.add(db_documento)
    db.commit()
    db.refresh(db_documento)
    return db_documento

@router.get("/", response_model=List[schemas.Documento])
def read_documentos(skip: int = 0, limit: int = 100, db: Session = Depends(get_db)):
    documentos = db.query(models.Documento).offset(skip).limit(limit).all()
    return documentos

@router.get("/{doc_id}", response_model=schemas.Documento)
def read_documento(doc_id: int, db: Session = Depends(get_db)):
    db_documento = db.query(models.Documento).filter(models.Documento.doc_id == doc_id).first()
    if db_documento is None:
        raise HTTPException(status_code=404, detail="Documento not found")
    return db_documento

@router.put("/{doc_id}", response_model=schemas.Documento)
def update_documento(doc_id: int, documento: schemas.DocumentoCreate, db: Session = Depends(get_db)):
    db_documento = db.query(models.Documento).filter(models.Documento.doc_id == doc_id).first()
    if db_documento is None:
        raise HTTPException(status_code=404, detail="Documento not found")
    for key, value in documento.dict().items():
        setattr(db_documento, key, value)
    db.commit()
    db.refresh(db_documento)
    return db_documento

@router.delete("/{doc_id}")
def delete_documento(doc_id: int, db: Session = Depends(get_db)):
    db_documento = db.query(models.Documento).filter(models.Documento.doc_id == doc_id).first()
    if db_documento is None:
        raise HTTPException(status_code=404, detail="Documento not found")
    db.delete(db_documento)
    db.commit()
    return {"detail": "Documento deleted"}