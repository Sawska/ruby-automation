require 'minitest/autorun'
require 'minitest/reporters'
require 'date'
require_relative 'student'

Minitest::Reporters.use! [Minitest::Reporters::HtmlReporter.new]

describe Student do
  before do
    Student.class_variable_set(:@@students, [])
  end

  describe '#initialize' do
    it 'creates a student with valid data' do
      student = Student.new("Anatski", "Vasul", Date.new(2000, 1, 15))
      _(student.surname).must_equal "Anatski"
      _(student.name).must_equal "Vasul"
      _(student.date_of_birth).must_equal Date.new(2000, 1, 15)
    end

    it 'raises an error when date of birth is in the future' do
      _(proc { Student.new("Anatski", "Vasul", Date.today + 1) }).must_raise(ArgumentError)
    end
  end

  describe '#calculate_age' do
    it 'calculates the correct age' do
      dob = Date.new(2000, 1, 15)
      student = Student.new("Tesleva", "Maryana", dob)
      expected_age = Date.today.year - dob.year - (Date.today < dob + ((Date.today.year - dob.year) * 365) ? 1 : 0)
      _(student.calculate_age).must_equal expected_age
    end
  end

  describe 'student management' do
    it 'adds unique students' do
      student1 = Student.new("Antonyk", "Kiril", Date.new(2000, 1, 15))
      student2 = Student.new("Pechansky", "Oleg", Date.new(1999, 5, 10))
      _(Student.all_students.size).must_equal 2
    end

    it 'does not add duplicate students' do
      student1 = Student.new("Tesleva", "Maryana", Date.new(2000, 1, 15))
      student2 = Student.new("Tesleva", "Maryana", Date.new(2000, 1, 15))
      _(Student.all_students.size).must_equal 1
    end

    it 'removes students' do
      student = Student.new("Panchenko", "Polina", Date.new(2000, 1, 15))
      _(Student.all_students.size).must_equal 1
      student.remove_student
      _(Student.all_students.size).must_equal 0
    end
  end

  describe '.get_students_by_age' do
    it 'retrieves students of a specific age' do
      student1 = Student.new("Panchenko", "Polina", Date.new(2000, 1, 15))
      student2 = Student.new("Antonyk", "Kiril", Date.new(1995, 5, 10))
      target_age = student1.calculate_age
      _(Student.get_students_by_age(target_age)).must_equal [student1]
    end
  end

  describe '.get_students_by_name' do
    it 'retrieves students by name' do
      student1 = Student.new("Olegovich", "Kiril", Date.new(2000, 1, 15))
      student2 = Student.new("Antonyk", "Kiril", Date.new(1995, 5, 10))
      _(Student.get_students_by_name("Kiril")).must_equal [student1, student2]
    end
  end

  after do
    Student.class_variable_set(:@@students, [])
  end
end
