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
    <title>Mostrar Cita con el Médico</title>
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
</head>
<body>
    <div class="container">
        <h1>Mostrar Citas con el Médico</h1>
        <table class="table">
            <thead>
                <tr>
                    <th>ID</th>
                    <th>Fecha</th>
                    <th>Hora</th>
                    <th>Médico</th>
                    <th>Especialidad</th>
                    <th>Estado</th>
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
                            conexion = DriverManager.getConnection("jdbc:mysql://localhost/dbeps", "root", "123");

                            // Seleccionar citas médicas del cliente actual
                            String selectSQL = "SELECT cm.idcitaMedica, cm.fecha, cm.hora, CONCAT(m.nombre, ' ', m.apellido) AS medico_nombre, m.especialidad, cm.estado " +
                                    "FROM citaMedica cm " +
                                    "INNER JOIN medico m ON cm.medico_idmedico = m.idmedico " +
                                    "WHERE cm.cliente_idcliente = ?";
                            pstmt = conexion.prepareStatement(selectSQL);
                            pstmt.setInt(1, idCliente);
                            ResultSet rs = pstmt.executeQuery();

                            // Procesar los resultados
                            while (rs.next()) {
                                int idCita = rs.getInt("idcitaMedica");
                                String fecha = rs.getString("fecha");
                                String hora = rs.getString("hora");
                                String medicoNombre = rs.getString("medico_nombre");
                                String especialidad = rs.getString("especialidad");
                                String estado = rs.getString("estado");
                %>
                <tr>
                    <td><%= idCita %></td>
                    <td><%= fecha %></td>
                    <td><%= hora %></td>
                    <td><%= medicoNombre %></td>
                    <td><%= especialidad %></td>
                    <td><%= estado %></td>
                </tr>
                <%
                            }
                        } else {
                %>
                <tr>
                    <td colspan="6">No se ha iniciado sesión.</td>
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
