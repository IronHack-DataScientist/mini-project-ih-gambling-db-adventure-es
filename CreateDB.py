import pandas as pd
from sqlalchemy import create_engine, text

def create_database(db_name="IronHack_Gambling", username="root", password="Custom1234", host="localhost"):
    # Crea el motor de SQLAlchemy sin especificar la base de datos
    engine = create_engine(f'mysql+pymysql://{username}:{password}@{host}', echo=True)

    # Ejecutar el comando para crear la base de datos utilizando un bloque 'with'
    with engine.connect() as conn:
        conn.execute(text(f"CREATE DATABASE IF NOT EXISTS {db_name}"))
        conn.execute(text(f"USE {db_name}"))

    # Retorna el motor de la base de datos específica
    return create_engine(f'mysql+pymysql://{username}:{password}@{host}/{db_name}', echo=True)

# Leer los datos de Excel
file_path = '../mini-project-ih-gambling-db-adventure-es/dataset/SQL Test Data.xlsx'
xls = pd.ExcelFile(file_path)
sheet_names = [sheet for sheet in xls.sheet_names if sheet != 'Student_School'][:4]
data_frames = {sheet: pd.read_excel(xls, sheet_name=sheet) for sheet in sheet_names}

# Conectar a MySQL y crear la base de datos
db_engine = create_database(db_name="IronHack_Gambling", username="root", password="Custom1234", host="localhost")

# Cargar los datos en MySQL
for sheet_name, df in data_frames.items():
    df.to_sql(sheet_name.lower(), con=db_engine, if_exists='replace', index=False)
