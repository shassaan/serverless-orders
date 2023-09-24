import psycopg2
class PostGres:
  def __init__(self,host,port,db_name,username,password) -> None:
    self.host = host
    self.port = port
    self.db_name = db_name
    self.username = username
    self.password = password


  def create_engine(self):
    if self.engine:
      return

    self.engine = psycopg2.connect(
                host = self.host, port = self.port, database = self.db_name,
                user = self.username, password = self.password
            )
    self.cursor = self.engine.cursor()


  def close_engine(self):
    if self.cursor:
      self.cursor.close()
    if self.engine:
      self.engine.close()

  def create_database_if_not_exist(self):
    self.create_engine()
    self.cursor.execute(f"""SELECT 'CREATE DATABASE {self.db_name}' WHERE NOT EXISTS (SELECT FROM pg_database WHERE datname = '{self.db_name}')\gexec""")
    self.engine.commit()
    self.close_engine()
  
  def create_table_if_not_exist(self,command):
    self.create_engine()
    self.cursor.execute(command)
    self.engine.commit()
    self.close_engine()
  
  def fetch_data(self, query):
    self.create_engine()
    self.cursor.execute(query)
    list = self.cursor.fetchall()
    self.close_engine()
    return list
  
  def insert_row(self, command):
    self.create_engine()
    self.cursor.execute(command)
    self.engine.commit()
    self.close_engine()

