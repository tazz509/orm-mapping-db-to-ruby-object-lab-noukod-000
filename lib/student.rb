class Student
  attr_accessor :id, :name, :grade

  def self.new_from_db(row)
    # create a new Student object given a row from the database
    new_student = self.new
    new_student.id = row[0]
    new_student.name = row[1]
    new_student.grade = row[2]
    new_student
  end

  def self.all
    # retrieve all the rows from the "Students" database
    # remember each row should be a new instance of the Student class
    sql = <<-SQL
            select *
            from students
          SQL
    rows = DB[:conn].execute(sql)
    all = rows.map {|row| self.new_from_db(row)}
  end

  def self.find_by_name(name)
    # find the student in the database given a name
    # return a new instance of the Student class
     sql = <<-SQL
            select *
            from students
            where name = ?
          SQL
    rows = DB[:conn].execute(sql, name)
    result = rows.map {|row| self.new_from_db(row)}.first
  end

  def self.all_students_in_grade_9
    sql = <<-SQL
        select *
        from students
        where grade = 9
      SQL
    rows = DB[:conn].execute(sql)
    result = rows.map {|row| self.new_from_db(row)}
  end

  def self.students_below_12th_grade
    sql = <<-SQL
      select *
      from students
      where grade < 12
      SQL
    rows = DB[:conn].execute(sql)
    result = rows.map {|row| self.new_from_db(row)}
  end

  def self.first_X_students_in_grade_10(x)
    sql = <<-SQL
      select *
      from students
      where grade = 10
      limit ?
      SQL
    rows = DB[:conn].execute(sql, x)
    result = rows.map {|row| self.new_from_db(row)}
  end

  def self.first_student_in_grade_10
    sql = <<-SQL
      select *
      from students
      where grade = 10
      order by id
      SQL
    rows = DB[:conn].execute(sql)
    result = rows.map {|row| self.new_from_db(row)}.first
  end

  def self.all_students_in_grade_X(grade)
    sql = <<-SQL
      select *
      from students
      where grade = ?
      SQL
    rows = DB[:conn].execute(sql, grade)
    result = rows.map {|row| self.new_from_db(row)}
  end

  def save
    sql = <<-SQL
      INSERT INTO students (name, grade)
      VALUES (?, ?)
    SQL

    DB[:conn].execute(sql, self.name, self.grade)
  end

  def self.create_table
    sql = <<-SQL
    CREATE TABLE IF NOT EXISTS students (
      id INTEGER PRIMARY KEY,
      name TEXT,
      grade TEXT
    )
    SQL

    DB[:conn].execute(sql)
  end

  def self.drop_table
    sql = "DROP TABLE IF EXISTS students"
    DB[:conn].execute(sql)
  end


end
