require_relative 'spec_helper'

describe Student do

  before do
    Student.create_table
  end

  after do
    Student.drop_table
  end

  let(:pat) {Student.new}
  let(:sam) {Student.new}
  let(:jess) {Student.new}
  let(:attributes) {
    {
      :id => 1,
      :name => 'Pat',
      :grade => 12
    }
  }

  describe 'attributes' do
    it 'has an id, name, grade' do
      pat.id = attributes[:id]
      pat.name = attributes[:name]
      pat.grade = attributes[:grade]

      expect(pat.id).to eq(attributes[:id])
      expect(pat.name).to eq(attributes[:name])
      expect(pat.grade).to eq(attributes[:grade])
    end
  end

  describe '.create_table' do
    it 'creates a student table' do
      Student.drop_table
      Student.create_table

      table_check_sql = "SELECT tbl_name FROM sqlite_master WHERE type='table' AND tbl_name='students';"
      expect(DB[:conn].execute(table_check_sql)[0]).to eq(['students'])
    end
  end

  describe '.drop_table' do
    it "drops the student table" do
      Student.create_table
      Student.drop_table

      table_check_sql = "SELECT tbl_name FROM sqlite_master WHERE type='table' AND tbl_name='students';"
      expect(DB[:conn].execute(table_check_sql)[0]).to be_nil
    end
  end

  describe "#save" do
    it 'saves an instance of the Student class to the database' do
      pat.save
      expect(DB[:conn].execute("SELECT * FROM students")).to eq([[1, nil, nil]])
    end
  end

  describe '.new_from_db' do
    it 'creates an instance with corresponding attribute values' do
      row = [1, "Pat", 12]
      pat = Student.new_from_db(row)

      expect(pat.id).to eq(row[0])
      expect(pat.name).to eq(row[1])
      expect(pat.grade).to eq(row[2])
    end
  end

  describe 'retrieving data from the db' do
    describe '.find_by_name' do

      it 'returns an instance of student that matches the name from the DB' do
        pat.name = "Pat"
        pat.grade = 12
        pat.save

        pat_from_db = Student.find_by_name("Pat")
        expect(pat_from_db.name).to eq("Pat")
        expect(pat_from_db).to be_an_instance_of(Student)
      end
    end

    describe '.count_all_students_in_grade_9' do
      it 'returns an array of all students in grades 9' do
        pat.name = "Pat"
        pat.grade = 12
        pat.save
        sam.name = "Sam"
        sam.grade = 9
        sam.save

        all_in_9 = Student.count_all_students_in_grade_9
        expect(all_in_9.size).to eq(1)
      end
    end

    describe '.students_below_12th_grade' do
      it 'returns an array of all students in grades 11 or below' do
        pat.name = "Pat"
        pat.grade = 12
        pat.save
        sam.name = "Sam"
        sam.grade = 10
        sam.save

        all_but_12th = Student.students_below_12th_grade
        expect(all_but_12th.size).to eq(1)
      end
    end

    describe '.all' do
      it 'returns all student instances from the db' do
        pat.name = "Pat"
        pat.grade = 12
        pat.save
        sam.name = "Sam"
        sam.grade = 10
        sam.save

        all_from_db = Student.all
        expect(all_from_db.size).to eq(2)
        expect(all_from_db.last).to be_an_instance_of(Student)
        expect(all_from_db.any? {|student| student.name == "Sam"}).to eq(true)
      end
    end

    describe '.first_x_students_in_grade_10' do
      it 'returns an array of the first X students in grade 10' do

        pat.name = "Pat"
        pat.grade = 10
        pat.save
        sam.name = "Sam"
        sam.grade = 10
        sam.save
        jess.name = "Jess"
        jess.grade = 10
        jess.save

        first_x_students = Student.first_x_students_in_grade_10(2)
        expect(first_x_students.size).to eq(2)
      end
    end

    describe '.first_student_in_grade_10' do
      it 'returns the first student in grade 10' do
        pat.name = "Pat"
        pat.grade = 12
        pat.id = 1
        pat.save

        sam.name = "Sam"
        sam.grade = 10
        sam.id = 2
        sam.save

        jess.name = "Jess"
        jess.grade = 10
        jess.id = 3
        jess.save

        first_student = Student.first_student_in_grade_10
        expect(first_student.id).to eq(2)
        expect(first_student.name).to eq("Sam")
      end
    end

    describe '.all_students_in_grade_x' do
      it 'returns an array of all students in a given grade X' do
        pat.name = "Pat"
        pat.grade = 10
        pat.save
        sam.name = "Sam"
        sam.grade = 10
        sam.save
        jess.name = "Jess"
        jess.grade = 10
        jess.save

        tenth_grade = Student.all_students_in_grade_x(10)
        expect(tenth_grade.size).to eq(3)
      end
    end
  end
end
