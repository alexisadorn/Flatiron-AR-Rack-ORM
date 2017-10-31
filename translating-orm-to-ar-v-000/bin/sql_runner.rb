class SQLRunner
  def initialize(db)
    @db = db
  end

  def execute_schema_migration_sql
    sql = File.read('db/create.sql')
    execute_sql(sql)
  end

  def execute_sql(sql)
     sql.scan(/[^;]*;/m).each { |line| @db.execute(line) } unless sql.empty?
  end
end
