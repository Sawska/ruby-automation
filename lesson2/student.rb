require 'date'

class Student
  attr_accessor :surname, :name, :date_of_birth

  @@students = []

  def initialize(surname, name, date_of_birth)
    @surname = surname
    @name = name
    @date_of_birth = date_of_birth

    raise ArgumentError, "Date of birth must be in the past" if date_of_birth >= Date.today

    add_student
  end

  def calculate_age
    now = Date.today
    age = now.year - @date_of_birth.year
    age -= 1 if now < @date_of_birth + age * 365 
    age
  end
  

  def add_student
    unless @@students.any? { |s| s.surname == @surname && s.name == @name && s.date_of_birth == @date_of_birth }
      @@students << self
    end
  end

  def remove_student
    @@students.delete_if { |s| s.surname == @surname && s.name == @name && s.date_of_birth == @date_of_birth }
  end

  def self.get_students_by_age(age)
    @@students.select { |student| student.calculate_age == age }
  end

  def self.get_students_by_name(name)
    @@students.select { |student| student.name == name }
  end

  def self.all_students
    @@students
  end
end
