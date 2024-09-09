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
    <title>Eliminar Cita Médica</title>
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
</head>
<body>
    <div class="container">
        <h1 class="mt-5 mb-4">Eliminar Cita Médica</h1>
        <form method="post">
            <div class="form-group">
                <label for="citaMedica">Seleccionar cita:</label>
                <select class="form-control" id="citaMedica" name="citaMedica_id">
                    <% 
                        Connection conexion = null;
                        PreparedStatement pstmt = null;
                        try {
                            // Establecer la conexión
                            Class.forName("com.mysql.jdbc.Driver");
                            conexion = DriverManager.getConnection("jdbc:mysql://localhost/dbeps", "root", "123456");

                            // Consulta para obtener las citas médicas del médico
                            String selectSQL = "SELECT cm.idcitaMedica, cm.fecha, cm.hora, c.nombre, c.apellido " +
                                              "FROM citamedica cm " +
                                              "INNER JOIN cliente c ON cm.cliente_idcliente = c.idcliente " +
                                              "WHERE cm.medico_idmedico = ?";
                            pstmt = conexion.prepareStatement(selectSQL);
                            pstmt.setInt(1, (Integer) session.getAttribute("idMedico"));
                            ResultSet rs = pstmt.executeQuery();

                            // Procesar los resultados y generar las opciones del select
                            while (rs.next()) {
                                int idCitaMedica = rs.getInt("idcitaMedica");
                                String fecha = rs.getString("fecha");
                                String hora = rs.getString("hora");
                                String nombreCliente = rs.getString("nombre") + " " + rs.getString("apellido");
                    %>
                    <option value="<%= idCitaMedica %>">
                        <%= "Fecha: " + fecha + " - Hora: " + hora + " - Cliente: " + nombreCliente %>
                    </option>
                    <%-- Aquí se agregan las opciones de las citas médicas al formulario --%>
                    <%
                            }
                        } catch (ClassNotFoundException | SQLException e) {
                            e.printStackTrace();
                        } finally {
                            try {
                                if (pstmt != null) pstmt.close();
                                if (conexion != null) conexion.close();
                            } catch (SQLException e) {
                                e.printStackTrace();
                            }
                        }
                    %>
                </select>
            </div>
            <button type="submit" class="btn btn-danger">Eliminar Cita Médica</button>
            <button type="button" class="btn btn-secondary" onclick="location.href='principal.jsp';">Volver</button>
        </form>
        <% 
            // Procesar el envío del formulario para eliminar la cita médica
            if ("POST".equals(request.getMethod())) {
                int idCitaMedica = Integer.parseInt(request.getParameter("citaMedica_id"));
                try {
                    // Establecer la conexión
                    conexion = DriverManager.getConnection("jdbc:mysql://localhost/dbeps", "root", "123456");

                    // Eliminar la cita médica
                    pstmt = conexion.prepareStatement("DELETE FROM citamedica WHERE idcitaMedica = ?");
                    pstmt.setInt(1, idCitaMedica);
                    int filasEliminadas = pstmt.executeUpdate();

                    // Mostrar mensaje de éxito
        %>
        <div class='alert alert-success mt-3'>Cita médica eliminada exitosamente</div>
        <%
                } catch (SQLException e) {
                    e.printStackTrace();
                    // Mostrar mensaje de error
        %>
        <div class='alert alert-danger mt-3'>Error al eliminar la cita médica</div>
        <%
                } finally {
                    try {
                        if (pstmt != null) pstmt.close();
                        if (conexion != null) conexion.close();
                    } catch (SQLException e) {
                        e.printStackTrace();
                    }
                }
            }
        %>
    </div>
</body>
</html>
