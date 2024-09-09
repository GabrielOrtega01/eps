<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.Connection" %>
<%@ page import="java.sql.PreparedStatement" %>
<%@ page import="java.sql.DriverManager" %>
<%@ page import="java.sql.SQLException" %>
<%@ page import="java.sql.ResultSet" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Mostrar Administradores</title>
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
</head>
<body style="background-image: url('imagendefondo.jpg'); background-size: cover; background-position: center;">
    <div class="container">
        <h1 class="mt-5 mb-4">Lista de Administradores</h1>

        <table class="table">
            <thead>
                <tr>
                    <th>ID</th>
                    <th>Documento</th>
                    <th>Nombre</th>
                    <th>Apellido</th>
                    <!-- Agregar más columnas según sea necesario -->
                </tr>
            </thead>
            <tbody>
                <% 
                    Connection conexion = null;
                    PreparedStatement pstmt = null;
                    ResultSet rs = null;
                    try {
                        // Establecer la conexión
                        Class.forName("com.mysql.jdbc.Driver");
                        conexion = DriverManager.getConnection("jdbc:mysql://localhost/dbeps", "root", "123456");

                        // Consulta para obtener todos los administradores
                        String selectSQL = "SELECT * FROM administrador";
                        pstmt = conexion.prepareStatement(selectSQL);
                        rs = pstmt.executeQuery();

                        // Procesar los resultados y mostrarlos en la tabla
                        while (rs.next()) {
                            int idAdministrador = rs.getInt("idadministrador");
                            String documento = rs.getString("documento");
                            String nombre = rs.getString("nombre");
                            String apellido = rs.getString("apellido");
                %>
                <tr>
                    <td><%= idAdministrador %></td>
                    <td><%= documento %></td>
                    <td><%= nombre %></td>
                    <td><%= apellido %></td>
                    <!-- Agregar más columnas según sea necesario -->
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

        <!-- Botón para regresar -->
        <button type="button" class="btn btn-secondary" onclick="location.href='principal.jsp';">Regresar</button>
    </div>
</body>
</html>
