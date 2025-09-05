package com.net.DAO;

import java.sql.*;
import com.net.bean.ResultBean;

public class ResultDAO {
    static String dclass = "com.mysql.cj.jdbc.Driver";
    static String url = "jdbc:mysql://localhost:3306/result_student";
    static String username = "root";
    static String password = "";
    static Connection con = null;
    static int status = 0;
    static Statement st = null;
    static PreparedStatement ps = null;
    static ResultSet rs = null;

    public static int Register(ResultBean rb) {
        try {
            Class.forName(dclass);
            con = DriverManager.getConnection(url, username, password);
            
            // Check if student exists and get their details
            String checkStudent = "SELECT course, branch, semester FROM students WHERE rollNo = ?";
            ps = con.prepareStatement(checkStudent);
            ps.setInt(1, rb.getRollNo());
            rs = ps.executeQuery();
            
            if (!rs.next()) {
                return 0; // Student doesn't exist
            }
            
            String studentCourse = rs.getString("course");
            String studentBranch = rs.getString("branch");
            int studentSemester = rs.getInt("semester");
            
            // Check if subject exists and get its details
            String checkSubject = "SELECT course, branch, semester FROM subjects WHERE subject_code = ?";
            ps = con.prepareStatement(checkSubject);
            ps.setString(1, rb.getSubjectCode());
            rs = ps.executeQuery();
            
            if (!rs.next()) {
                return 0; // Subject doesn't exist
            }
            
            String subjectCourse = rs.getString("course");
            String subjectBranch = rs.getString("branch");
            int subjectSemester = rs.getInt("semester");
            
            // Check if course, branch and semester match
            if (!studentCourse.equals(subjectCourse) || 
                !studentBranch.equals(subjectBranch) || 
                studentSemester != subjectSemester) {
                return -1; // Course, branch or semester mismatch
            }
            
            // Check if result already exists
            String checkResult = "SELECT * FROM results WHERE rollNo = ? AND subject_code = ?";
            ps = con.prepareStatement(checkResult);
            ps.setInt(1, rb.getRollNo());
            ps.setString(2, rb.getSubjectCode());
            rs = ps.executeQuery();
            
            if (rs.next()) {
                return 0; // Result already exists
            }
            
            // Insert new result
            String sql = "insert into results(rollNo, subject_code, marks) values(?,?,?)";
            ps = con.prepareStatement(sql);
            ps.setInt(1, rb.getRollNo());
            ps.setString(2, rb.getSubjectCode());
            ps.setInt(3, rb.getMarks());
            
            status = ps.executeUpdate();
            
        } catch (ClassNotFoundException | SQLException e) {
            e.printStackTrace();
        }
        return status;
    }
} 