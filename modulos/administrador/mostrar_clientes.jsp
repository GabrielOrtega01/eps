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
    <title>Listado de Clientes</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/twitter-bootstrap/4.6.0/css/bootstrap.min.css">
    <style>
        body {
            background-color: #f8f9fa;
        }
        .container {
            margin-top: 50px;
        }
        h1 {
            text-align: center;
            margin-bottom: 30px;
        }
        table {
            background-color: #fff;
        }
        th, td {
            padding: 10px;
            text-align: center;
        }
        .footer {
            background-color: #343a40;
            color: #ffffff;
            text-align: center;
            padding: 20px 0;
            position: fixed;
            bottom: 0;
            width: 100%;
        }
    </style>
</head>
<body>
    <div class="container">
        <h1>Listado de Clientes</h1>
        
        <table class="table table-bordered">
            <thead class="thead-dark">
                <tr>
                    <th>ID</th>
                    <th>Documento</th>
                    <th>Nombre</th>
                    <th>Apellido</th>
                    <th>Estado Civil</th>
                    <th>Dirección</th>
                    <th>Correo</th>
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

                        String selectSQL = "SELECT * FROM cliente";
                        pstmt = conexion.prepareStatement(selectSQL);
                        rs = pstmt.executeQuery();

                        while (rs.next()) {
                %>
                <tr>
                    <td><%= rs.getInt("idcliente") %></td>
                    <td><%= rs.getString("documento") %></td>
                    <td><%= rs.getString("nombre") %></td>
                    <td><%= rs.getString("apellido") %></td>
                    <td><%= rs.getString("estadoCivil") %></td>
                    <td><%= rs.getString("direccion") %></td>
                    <td><%= rs.getString("correo") %></td>
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

        <!-- Botón de Regresar -->
        <button type="button" class="btn btn-secondary" onclick="location.href='principal.jsp';">Volver</button>
        <!-- End of Botón de Regresar -->
    </div>

    <!-- Footer -->
    <footer class="footer">
        <div class="container">
            <p>&copy; 2024 EPS Securitas. Todos los derechos reservados.</p>
        </div>
    </footer>
    <!-- End of Footer -->
</body>
</html>
