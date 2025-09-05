package com.net.DAO;

import java.sql.*;
import com.net.bean.SubjectBean;

public class SubjectDAO {
    static String dclass = "com.mysql.cj.jdbc.Driver";
    static String url = "jdbc:mysql://localhost:3306/result_student";
    static String username = "root";
    static String password = "";
    static Connection con = null;
    static int status = 0;
    static Statement st = null;
    static PreparedStatement ps = null;
    static ResultSet rs = null;

    public static int Register(SubjectBean sb) {
        try {
            Class.forName(dclass);
            con = DriverManager.getConnection(url, username, password);
            String sql = "insert into subjects(subject_code, subject_name, course, branch, semester) values(?,?,?,?,?)";
            ps = con.prepareStatement(sql);
            ps.setString(1, sb.getSubjectCode());
            ps.setString(2, sb.getSubjectName());
            ps.setString(3, sb.getCourse());
            ps.setString(4, sb.getBranch());
            ps.setInt(5, sb.getSemester());

            status = ps.executeUpdate();

        } catch (ClassNotFoundException e) {
            e.printStackTrace();
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return status;
    }
} 