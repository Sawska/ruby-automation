require 'minitest/autorun'
require 'minitest/reporters'
require 'date'
require_relative 'student' 

Minitest::Reporters.use! [Minitest::Reporters::HtmlReporter.new]

class StudentTest < Minitest::Test
  def setup
    Student.class_variable_set(:@@students, [])
  end

  def test_initialize_with_valid_data
    student = Student.new("Anatski", "Vasul", Date.new(2000, 1, 15))
    assert_equal "Anatski", student.surname
    assert_equal "Vasul", student.name
    assert_equal Date.new(2000, 1, 15), student.date_of_birth
  end

  def test_initialize_with_invalid_date_of_birth
    assert_raises(ArgumentError) do
      Student.new("Anatski", "Vasul", Date.today + 1)
    end
  end

  def test_calculate_age
    dob = Date.new(2000, 1, 15)
    student = Student.new("Tesleva", "Maryana", dob)
    expected_age = Date.today.year - dob.year - (Date.today < dob + ((Date.today.year - dob.year) * 365) ? 1 : 0)
    assert_equal expected_age, student.calculate_age
  end

  def test_add_student_unique
    student1 = Student.new("Antonyk", "kiril", Date.new(2000, 1, 15))
    student2 = Student.new("Pechansky", "Oleg", Date.new(1999, 5, 10))
    assert_equal 2, Student.all_students.size
  end

  def test_add_student_duplicate
    student1 = Student.new("Tesleva", "Maryana", Date.new(2000, 1, 15))
    student2 = Student.new("Tesleva", "Maryana", Date.new(2000, 1, 15))
    assert_equal 1, Student.all_students.size
  end

  def test_remove_student
    student = Student.new("Panchenko", "Polina", Date.new(2000, 1, 15))
    assert_equal 1, Student.all_students.size
    student.remove_student
    assert_equal 0, Student.all_students.size
  end

  def test_get_students_by_age
    student1 = Student.new("Panchenko", "Polina", Date.new(2000, 1, 15))
    student2 = Student.new("Antonyk", "Kiril", Date.new(1995, 5, 10))
    target_age = student1.calculate_age
    assert_equal [student1], Student.get_students_by_age(target_age)
  end

  def test_get_students_by_name
    student1 = Student.new("Olegovich", "Kiril", Date.new(2000, 1, 15))
    student2 = Student.new("Antonyk", "Kiril", Date.new(1995, 5, 10))
    assert_equal [student1, student2], Student.get_students_by_name("Kiril")
  end

  def teardown
    Student.class_variable_set(:@@students, [])
  end
end
