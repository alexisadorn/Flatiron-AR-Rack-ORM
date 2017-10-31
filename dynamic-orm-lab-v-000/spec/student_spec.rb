require_relative 'spec_helper'

describe Student do
  before :each do
    DB[:conn].execute("DROP TABLE IF EXISTS students")

    sql = <<-SQL
      CREATE TABLE IF NOT EXISTS students (
      id INTEGER PRIMARY KEY, 
      name TEXT, 
      grade INTEGER
      )
    SQL

    DB[:conn].execute(sql)
    DB[:conn].results_as_hash = true
  end

  let(:attributes) {
    {
      id: nil,
      name: "Sam",
      grade: 11
    } 
  }

  let(:new_student) {Student.new(attributes)}

  describe 'inheritance' do
    it 'inherits from InteractiveRecord class' do
      expect(Student).to be < InteractiveRecord 
    end
  end

  describe '.table_name' do 
    it 'creates a downcased, plural table name based on the Class name' do 
      expect(Student.table_name).to eq('students')
    end
  end

  describe '.column_names' do 
    it 'returns an array of SQL column names' do 
      expect(Student.column_names).to eq(["id", "name", "grade"])
    end
  end

  describe 'initialize' do 
    it 'creates an new instance of a student' do 
      expect(Student.new).to be_a Student
    end

    it 'creates a new student with attributes' do 
      expect(new_student.name).to eq("Sam")
    end
  end  
  
  describe 'attr_accessor' do 
    it 'creates attr_accessors for each column name' do 
      old_name = new_student.name
      new_name = new_student.name = "Jo"
      old_grade = new_student.grade
      new_grade = new_student.grade = 12
      expect(old_name).to eq("Sam")
      expect(new_name).to eq("Jo")
      expect(old_grade).to eq(11)
      expect(new_grade).to eq(12)
    end
  end

  context 'has instance methods to insert data into db' do 
    describe '#table_name_for_insert' do 
      it 'return the table name when called on an instance of Student' do 
        expect(new_student.table_name_for_insert).to eq("students")
      end
    end

    describe '#col_names_for_insert' do 
      it 'return the column names when called on an instance of Student' do 
        expect(new_student.col_names_for_insert).to include("name, grade")
      end

      it 'does not include an id column' do 
        expect(new_student.col_names_for_insert).not_to include("id")
      end
    end

    describe '#values_for_insert' do 
      it 'formats the column names to be used in a SQL statement' do 
        expect(new_student.values_for_insert).to eq("'Sam', '11'")
      end
    end
    
    describe '#save' do 
      it 'saves the student to the db' do 
        new_student.save
        expect(DB[:conn].execute("SELECT * FROM students WHERE name = 'Sam'")).to eq([{"id"=>1, "name"=>"Sam", "grade"=>11, 0=>1, 1=>"Sam", 2=>11}])
      end

      it 'sets the student\'s id' do
        new_student.save
        expect(new_student.id).to eq(1)
      end
    end
  end

  describe '.find_by_name' do 
    it 'executes the SQL to find a row by name' do 
      Student.new({name: "Jan", grade: 10}).save
      expect(Student.find_by_name("Jan")).to eq([{"id"=>1, "name"=>"Jan", "grade"=>10, 0=>1, 1=>"Jan", 2=>10}])
    end
  end

  describe '.find_by' do 
    it 'executes the SQL to find a row by the attribute passed into the method' do 
      Student.new({name: "Susan", grade: 10}).save
      expect(Student.find_by({name: "Susan"})).to eq([{"id"=>1, "name"=>"Susan", "grade"=>10, 0=>1, 1=>"Susan", 2=>10}])
    end

    it 'accounts for when an attribute value is an integer' do 
      Student.new({name: "Susan", grade: 10}).save
      expect(Student.find_by({grade: 10})).to eq([{"id"=>1, "name"=>"Susan", "grade"=>10, 0=>1, 1=>"Susan", 2=>10}])
    end
  end
end
