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
        <%-- Verificar si se ha enviado el parámetro de éxito en la URL --%>
        <% if ("true".equals(request.getParameter("success"))) { %>
            <div class="alert alert-success" role="alert">
                Los datos se actualizaron exitosamente.
            </div>
        <% } %>
        
        <%
            // Obtener el id del cliente autenticado desde la sesión
            Integer idCliente = (Integer) session.getAttribute("idCliente");
            if (idCliente != null) {
                Connection conexion = null;
                PreparedStatement pstmt = null;
                ResultSet rs = null;

                try {
                    Class.forName("com.mysql.jdbc.Driver");
                    conexion = DriverManager.getConnection("jdbc:mysql://localhost/dbeps", "root", "123456");

                    if (request.getParameter("estadoCivil") != null && request.getParameter("direccion") != null && request.getParameter("correo") != null) {
                        // Actualizar los datos personales del cliente
                        String updateSQL = "UPDATE cliente SET estadoCivil=?, direccion=?, correo=? WHERE idcliente=?";
                        pstmt = conexion.prepareStatement(updateSQL);
                        pstmt.setString(1, request.getParameter("estadoCivil"));
                        pstmt.setString(2, request.getParameter("direccion"));
                        pstmt.setString(3, request.getParameter("correo"));
                        pstmt.setInt(4, idCliente);
                        pstmt.executeUpdate();
                        
                        // Mostrar el mensaje de éxito
                        %><div class="alert alert-success" role="alert">Los datos se actualizaron exitosamente.</div><%
                    }

                    // Obtener los datos personales del cliente actualizados
                    String selectSQL = "SELECT documento, nombre, apellido, estadoCivil, direccion, correo FROM cliente WHERE idcliente=?";
                    pstmt = conexion.prepareStatement(selectSQL);
                    pstmt.setInt(1, idCliente);
                    rs = pstmt.executeQuery();

                    if (rs.next()) {
        %>
        <h2>Datos Personales</h2>
        <table class="table table-bordered">
            <tr>
                <th>Documento</th>
                <th>Nombre</th>
                <th>Apellido</th>
                <th>Estado Civil</th>
                <th>Dirección</th>
                <th>Correo</th>
                <th>Acciones</th>
            </tr>
            <tr>
                <td><%= rs.getString("documento") %></td>
                <td><%= rs.getString("nombre") %></td>
                <td><%= rs.getString("apellido") %></td>
                <td>
                    <form action="" method="post">
                        <input type="text" name="estadoCivil" value="<%= rs.getString("estadoCivil") %>" class="form-control">
                        <input type="hidden" name="idCliente" value="<%= idCliente %>">
                </td>
                <td><input type="text" name="direccion" value="<%= rs.getString("direccion") %>" class="form-control"></td>
                <td><input type="email" name="correo" value="<%= rs.getString("correo") %>" class="form-control"></td>
                <td>
                        <button type="submit" class="btn btn-primary">Actualizar</button>
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
                // Manejar el caso en el que el idCliente no está en la sesión
                out.println("<p>Error: No se ha iniciado sesión o falta el identificador del cliente.</p>");
            }
        %>
    </div>
</body>
</html>
