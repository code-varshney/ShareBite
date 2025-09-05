package com.net.DAO;

import java.sql.*;

import com.net.bean.StudentBean;

public class StudentDAO {
	
	static String dclass ="com.mysql.cj.jdbc.Driver";
	static String url ="jdbc:mysql://localhost:3306/result_student";
	static String username = "root";
	static String password = "";
	static Connection con = null;
	static int status = 0;
	static Statement st = null;
	static PreparedStatement ps  = null;
	
	static ResultSet rs = null;
	
    public static int Login(StudentBean sb) {
		
		try {
			Class.forName(dclass);
			
			con = DriverManager.getConnection(url, username, password);
			
			//String sql = "select uname from user where uname='"+ub.getUname()+"' and password='"+ub.getPassword()+"'";
			String sql ="select * from students where rollNo=? and password=?";
			
			ps = con.prepareStatement(sql);
			ps.setInt(1, sb.getRollNo());
			ps.setString(2, sb.getPassword());
			
			rs = ps.executeQuery();
			
			

			if(rs.next())
			{
				status = 1;
                sb.setName(rs.getString("name"));
                sb.setCourse(rs.getString("course"));
                sb.setBranch(rs.getString("branch"));
                sb.setSemester(rs.getInt("semester"));
                sb.setEmail(rs.getString("email"));
                
                
			}
			else
			{
				status = 0;
			}
		} catch (ClassNotFoundException | SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		
		return status;
	}


	public static int Register(StudentBean sb) {
		try {
			Class.forName(dclass);
			con = DriverManager.getConnection(url,username,password);
			String sql = "insert into students(rollNo, name, dob, email, city, course, branch, semester, password) values(?,?,?,?,?,?,?,?,?)";
			ps = con.prepareStatement(sql);
			ps.setInt(1,  sb.getRollNo());
			ps.setString(2,  sb.getName());
			ps.setString(3,  sb.getDob());
			ps.setString(4,  sb.getEmail());
			ps.setString(5,  sb.getCity());
			ps.setString(6,  sb.getCourse());
			ps.setString(7,  sb.getBranch());
			ps.setInt(8,  sb.getSemester());
			ps.setString(9,  sb.getPassword());
			
			
			
			status = ps.executeUpdate();
			
			//String sql = "insert into user (uname,password,name,email,dob,city) values('"+ub.getUname()+"','"+ub.getPassword()+"','"+ub.getName()+"','"+ub.getEmail()+"','"+ub.getDob()+"', '"+ub.getCity()+"')";
			//st = con.createStatement();
			//status = st.executeUpdate(sql);
			
		} catch (ClassNotFoundException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return status;
	}
	
	
} 