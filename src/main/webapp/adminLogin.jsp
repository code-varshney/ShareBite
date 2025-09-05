<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="ISO-8859-1">
	<title>Admin Login - Food Rescue App</title>
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <style>
       body {
	background: url('./bg.jpg') no-repeat center center fixed;
	background-size: cover;
	font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
	height: 100vh;
	position: relative;
	overflow: hidden;
}

body::before {
	content: '';
	position: fixed;
	top: -10px;
	left: -10px;
	right: -10px;
	bottom: -10px;
	background: rgba(0, 0, 0, 0.5);
	filter: blur(8px);
	-webkit-filter: blur(8px);
	z-index: 1;
}

.login-container {
      margin-top: 150px;
      position: relative;
      z-index: 2;
      padding-bottom: 50px;
    }

    .card {
      border-radius: 15px;
      box-shadow: 0 10px 20px rgba(0, 0, 0, 0.2);
      background: rgba(255, 255, 255, 0.95);
      padding: 2rem;
    }

    .logo-container {
      text-align: center;
      margin-bottom: 0.5rem;
    }

    .logo-container img {
      width: 250px;
      height: 100px;
      object-fit: contain;
    }

.system-title {
	color: #1e3c72;
	font-weight: 600;
	margin-top: 1rem;
	margin-bottom: 2rem;
}

.system-subtitle {
	color: #666;
	font-size: 0.9rem;
	margin-bottom: 2rem;
}

.form-control {
	border-radius: 8px;
	padding: 12px;
	border: 1px solid #ddd;
}

.form-control:focus {
	border-color: #1e3c72;
	box-shadow: 0 0 0 0.2rem rgba(30, 60, 114, 0.25);
}

.btn-login {
	background-color: #1e3c72;
	color: white;
	padding: 12px;
	font-weight: 500;
	border-radius: 8px;
	transition: all 0.3s ease;
}

.btn-login:hover {
	background-color: #2a5298;
	color: white;
	transform: translateY(-1px);
}

.form-label {
	font-weight: 500;
	color: #444;
}

.register-link {
	color: #1e3c72;
	text-decoration: none;
	font-weight: 500;
}

.register-link:hover {
	color: #2a5298;
	text-decoration: underline;
}
</style>
</head>

<body>

	<div class="container login-container">
		<div class="row justify-content-center">
			<div class="col-md-5">
				<div class="card">
					<div class="logo-container">
						
						<h2 class="text-center system-title">Admin Login</h2>
					</div>
				<% if(request.getParameter("error") != null) { %>
					<div class="alert alert-danger" role="alert">
						Invalid username or password!
					</div>
				<% } %>
					<form action="adminLoginProcess.jsp" method="post">
						<div class="mb-3">
							<label for="username" class="form-label">Username</label>
							<input type="text" class="form-control" id="username" name="username" placeholder="Enter your username" required>
						</div>
						<div class="mb-3">
							<label for="password" class="form-label">Password</label>
							<input type="password" class="form-control" id="password" name="password" placeholder="Enter your password" required>
						</div>
						<div class="d-grid">
							<button type="submit" class="btn btn-login">Sign In</button>
						</div>
					</form>

					
				</div>
			</div>
		</div>
	</div>

</body>
</html> 