<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.Connection" %>
<%@ page import="java.sql.PreparedStatement" %>
<%@ page import="java.sql.DriverManager" %>
<%@ page import="java.sql.ResultSet" %>
<%@ page import="java.sql.SQLException" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Mostrar Médicos - EPS Securitas</title>
    <!-- Bootstrap CSS -->
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
    <!-- Estilos personalizados -->
    <style>
        /* Estilos para el cuerpo de la tabla */
        body {
            background-color: #f8f9fa;
        }
        .container {
            background-color: #ffffff;
            border-radius: 10px;
            box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
            padding: 30px;
            margin-top: 50px;
        }
        /* Estilos para los botones */
        .btn-primary {
            background-color: #007bff;
            border-color: #007bff;
        }
        .btn-primary:hover {
            background-color: #0056b3;
            border-color: #0056b3;
        }
        /* Estilos para el footer */
        .footer {
            background-color: #343a40;
            color: #ffffff;
            text-align: center;
            position: fixed;
            bottom: 0;
            width: 100%;
            padding: 15px 0;
        }
    </style>
</head>
<body>
    <div class="container">
        <h1 class="mt-5 mb-4">Mostrar Médicos</h1>
        <table class="table table-bordered">
            <thead>
                <tr>
                    <th>Documento</th>
                    <th>Nombre</th>
                    <th>Apellido</th>
                    <th>Especialidad</th>
                </tr>
            </thead>
            <tbody>
                <% 
                    Connection conexion = null;
                    PreparedStatement pstmt = null;
                    ResultSet rs = null;
                    try {
                        Class.forName("com.mysql.jdbc.Driver");
                        conexion = DriverManager.getConnection("jdbc:mysql://localhost/dbeps", "root", "123456");
                        
                        String selectSQL = "SELECT documento, nombre, apellido, especialidad FROM medico";
                        pstmt = conexion.prepareStatement(selectSQL);
                        rs = pstmt.executeQuery();
                        
                        while (rs.next()) {
                %>
                <tr>
                    <td><%= rs.getString("documento") %></td>
                    <td><%= rs.getString("nombre") %></td>
                    <td><%= rs.getString("apellido") %></td>
                    <td><%= rs.getString("especialidad") %></td>
                </tr>
                <% 
                        }
                    } catch (ClassNotFoundException | SQLException e) {
                        e.printStackTrace();
                    } finally {
                        try {
                            if (rs != null) rs.close();
                            if (pstmt != null) pstmt.close();
                            if (conexion != null) conexion.close();
                        } catch (SQLException e) {
                            e.printStackTrace();
                        }
                    }
                %>
            </tbody>
        </table>
        <button type="button" class="btn btn-secondary" onclick="location.href='principal.jsp';">Volver</button>
       
    </div>

    <!-- Footer -->


    <!-- Bootstrap JS (opcional, si necesitas funcionalidades de Bootstrap) -->
    <script src="https://code.jquery.com/jquery-3.5.1.slim.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.5.4/dist/umd/popper.min.js"></script>
    <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>
</body>
</html>
