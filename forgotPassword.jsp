<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.Connection" %>
<%@ page import="java.sql.PreparedStatement" %>
<%@ page import="java.sql.DriverManager" %>
<%@ page import="java.sql.SQLException" %>
<%@ page import="java.sql.ResultSet" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Recuperar Contraseña</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/twitter-bootstrap/4.6.0/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css">
    <style>
        body {
            display: flex;
            flex-direction: column;
            align-items: center;
            font-family: Arial, sans-serif;
            background-color: #0E4B77;
            margin: 0;
            padding: 0;
            height: 100vh;
        }
        #login-container {
            text-align: center;
            max-width: 400px;
            padding: 20px;
            border: 1px solid #0C4067;
            border-radius: 10px;
            background-color: #3282B5;
            margin-top: 20px;
        }
        h1 {
            color: #B5E5FF;
            margin-bottom: 20px;
        }
        .alert {
            width: 100%;
            padding: 10px;
            margin-bottom: 20px;
            border-radius: 5px;
            transition: opacity 0.3s;
        }
        .alert-danger {
            background-color: #f8d7da;
            color: #721c24;
            border: 1px solid #f5c6cb;
        }
        .alert-success {
            background-color: #d4edda;
            color: #155724;
            border: 1px solid #c3e6cb;
        }
        .btn {
            width: 100%;
            padding: 10px;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            transition: background-color 0.3s;
            margin-top: 10px;
        }
        .btn-primary {
            background-color: #00C4CC;
            color: #201e1e;
        }
        .btn-volver {
            display: inline-block;
            padding: 10px 20px;
            background-color: #007bff;
            color: #fff;
            text-decoration: none;
            border-radius: 5px;
            margin-top: 20px;
        }
        .btn-volver:hover {
            background-color: #0056b3;
        }
    </style>
</head>
<body>
    <img id="logo" src="img/logotipo.png" alt="Logo de la Corporación" style="width: 30%; max-height: 50vh;">
    <div id="login-container">
        <h1>Recuperar Contraseña</h1>
        <%
            String document = request.getParameter("document");
            String userType = request.getParameter("userType");

            if (document != null && userType != null) {
                Connection connection = null;
                PreparedStatement statement = null;

                try {
                    Class.forName("com.mysql.jdbc.Driver");
                    connection = DriverManager.getConnection("jdbc:mysql://localhost/dbeps", "root", "123");

                    String query = "SELECT * FROM " + userType + " WHERE documento = ?";
                    statement = connection.prepareStatement(query);
                    statement.setString(1, document);
                    ResultSet resultSet = statement.executeQuery();

                    if (!resultSet.next()) {
        %>
                        <div class="alert alert-danger" role="alert">
                            Usuario inexistente. Por favor, verifique su documento.
                        </div>
        <%
                    } else {
                        query = "UPDATE " + userType + " SET clave = '000' WHERE documento = ?";
                        statement = connection.prepareStatement(query);
                        statement.setString(1, document);
                        statement.executeUpdate();
        %>
                        <div class="alert alert-success" role="alert">
                            La contraseña se ha restablecido. Su nueva contraseña es: 000
                        </div>
        <%
                    }
                } catch (ClassNotFoundException | SQLException e) {
                    e.printStackTrace();
                } finally {
                    try {
                        if (statement != null) statement.close();
                        if (connection != null) connection.close();
                    } catch (SQLException e) {
                        e.printStackTrace();
                    }
                }
            }
        %>
        <form id="forgot-password-form" action="" method="POST" style="display: flex; flex-direction: column; align-items: center;">
            <label for="document" style="margin-bottom: 10px; color: #D9D9D9;">Documento:</label>
            <input type="text" id="document" name="document" required style="width: 100%; padding: 8px; margin-bottom: 10px; border: 1px solid #ccc; border-radius: 5px;">
            <select name="userType" id="userType" style="width: 100%; padding: 8px; margin-bottom: 10px; border: 1px solid #ccc; border-radius: 5px;">
                <option value="cliente">Cliente</option>
                <option value="administrador">Administrador</option>
                <option value="medico">Médico</option>
            </select>
            <button type="submit" class="btn btn-primary">Recuperar contraseña</button>
        </form>
        <a href="login.jsp" class="btn-volver">Volver al inicio de sesión</a>
    </div>
       <footer class="bg-dark text-light text-center py-3" style="width: 100%; height: 100px;">
        <div class="container">
            <p>&copy; 2024 EPS Securitas. Todos los derechos reservados.</p>
        </div>
    </footer>
</body>
</html>
