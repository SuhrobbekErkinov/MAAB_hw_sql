import pyodbc

con_str = (
    "DRIVER=FreeTDS;"
    "SERVER=localhost;"
    "PORT=1433;"
    "DATABASE=hw2;"
    "UID=sa;"
    "PWD=1234qwertySQL;"
    "TDS_Version=8.0;"
)
con = pyodbc.connect(con_str)
cursor = con.cursor()

cursor.execute(
    """
    SELECT * FROM photos
    """
)

row = cursor.fetchone()
img_id, img_name, img_data = row

with open(f'{img_name}.png', 'wb') as f:
    f.write(img_data)