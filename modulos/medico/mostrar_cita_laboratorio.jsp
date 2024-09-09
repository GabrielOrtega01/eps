<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.Connection" %>
<%@ page import="java.sql.PreparedStatement" %>
<%@ page import="java.sql.DriverManager" %>
<%@ page import="java.sql.SQLException" %>
<%@ page import="java.sql.ResultSet" %>
<%@ page import="java.util.ArrayList" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Mostrar Cita con el Laboratorio</title>
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
</head>
<body>
    <div class="container">
        <h1>Mostrar Citas con el Laboratorio</h1>
        <table class="table">
            <thead>
                <tr>
                    <th>ID</th>
                    <th>Fecha</th>
                    <th>Hora</th>
                    <th>Estado</th>
                    <th>Laboratorio</th>
                </tr>
            </thead>
            <tbody>
                <% 
                    Connection conexion = null;
                    PreparedStatement pstmt = null;
                    try {
                        Integer idCliente = (Integer) session.getAttribute("idCliente");
                        if (idCliente != null) {
                            Class.forName("com.mysql.jdbc.Driver");
                            conexion = DriverManager.getConnection("jdbc:mysql://localhost/dbeps", "root", "123456");

                            // Seleccionar citas con el laboratorio del cliente actual
                            String selectSQL = "SELECT idcitaLaboratorio, fecha, hora, estado, nombre FROM citaLaboratorio " +
                                               "INNER JOIN Laboratorio ON citaLaboratorio.Laboratorio_idLaboratorio = Laboratorio.idLaboratorio " +
                                               "WHERE cliente_idcliente = ?";
                            pstmt = conexion.prepareStatement(selectSQL);
                            pstmt.setInt(1, idCliente);
                            ResultSet rs = pstmt.executeQuery();

                            // Procesar los resultados
                            while (rs.next()) {
                                int idCita = rs.getInt("idcitaLaboratorio");
                                String fecha = rs.getString("fecha");
                                String hora = rs.getString("hora");
                                String estado = rs.getString("estado");
                                String nombre = rs.getString("nombre");
                %>
                <tr>
                    <td><%= idCita %></td>
                    <td><%= fecha %></td>
                    <td><%= hora %></td>
                    <td><%= estado %></td>
                    <td><%= nombre%></td>
                </tr>
                <%
                            }
                        } else {
                %>
                <tr>
                    <td colspan="5">No se ha iniciado sesión.</td>
                </tr>
                <%
                        }
                    } catch (Exception e) {
                        e.printStackTrace();
                    } finally {
                        try {
                            if (pstmt != null) pstmt.close();
                            if (conexion != null) conexion.close();
                        } catch (Exception e) {
                            e.printStackTrace();
                        }
                    }
                %>
            </tbody>
        </table>
        <button type="button" class="btn btn-secondary" onclick="location.href='principal.jsp';">Volver</button>
    </div>
</body>
</html>
