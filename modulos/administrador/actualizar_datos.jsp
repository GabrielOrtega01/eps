
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
    <title>Actualizar Datos Personales</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/twitter-bootstrap/4.6.0/css/bootstrap.min.css">
</head>
<body>
    <div class="container">
        <h1>Actualizar Datos Personales</h1>
        
        <%
            // Obtener el id del administrador autenticado desde la sesión
            Integer idAdministrador = (Integer) session.getAttribute("idAdministrador");
            if (idAdministrador != null) {
                Connection conexion = null;
                PreparedStatement pstmt = null;
                ResultSet rs = null;

                try {
                    Class.forName("com.mysql.jdbc.Driver");
                    conexion = DriverManager.getConnection("jdbc:mysql://localhost/dbeps", "root", "123456");

                    if (request.getParameter("clave") != null) {
                        // Actualizar la clave del administrador
                        String updateSQL = "UPDATE administrador SET clave=? WHERE idadministrador=?";
                        pstmt = conexion.prepareStatement(updateSQL);
                        pstmt.setString(1, request.getParameter("clave"));
                        pstmt.setInt(2, idAdministrador);
                        pstmt.executeUpdate();
                        
                        // Mostrar el mensaje de éxito
                        out.println("<div class='alert alert-success' role='alert'>La clave se actualizó exitosamente.</div>");
                    }

                    // Obtener los datos personales del administrador
                    String selectSQL = "SELECT documento, nombre, apellido FROM administrador WHERE idadministrador=?";
                    pstmt = conexion.prepareStatement(selectSQL);
                    pstmt.setInt(1, idAdministrador);
                    rs = pstmt.executeQuery();

                    if (rs.next()) {
        %>
        <h2>Datos Personales</h2>
        <table class="table table-bordered">
            <tr>
                <th>Documento</th>
                <th>Nombre</th>
                <th>Apellido</th>
                <th>Clave</th>
                <th>Acciones</th>
            </tr>
            <tr>
                <td><%= rs.getString("documento") %></td>
                <td><%= rs.getString("nombre") %></td>
                <td><%= rs.getString("apellido") %></td>
                <td>
                    <form action="" method="post">
                        <input type="password" name="clave" class="form-control">
                </td>
                <td>
                        <button type="submit" class="btn btn-primary">Actualizar Clave</button>
                        <button type="button" class="btn btn-secondary" onclick="location.href='principal.jsp';">Volver</button>
                    </form>
                </td>
            </tr>
        </table>
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
            } else {
                // Manejar el caso en el que el idAdministrador no está en la sesión
                out.println("<p>Error: No se ha iniciado sesión o falta el identificador del administrador.</p>");
            }
        %>
    </div>
</body>
</html>
