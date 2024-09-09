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
    <title>Eliminar Cita con el Laboratorio</title>
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
</head>
<body>
    <div class="container">
        <h1 class="mt-5 mb-4">Eliminar Cita con el Laboratorio</h1>
        <form method="post">
            <div class="form-group">
                <label for="citaLaboratorio">Seleccionar cita:</label>
                <select class="form-control" id="citaLaboratorio" name="citaLaboratorio_id">
                    <% 
                        Connection conexion = null;
                        PreparedStatement pstmt = null;
                        try {
                            // Establecer la conexión
                            Class.forName("com.mysql.jdbc.Driver");
                            conexion = DriverManager.getConnection("jdbc:mysql://localhost/dbeps", "root", "123456");

                            // Consulta para obtener las citas con el laboratorio del cliente
                            String selectSQL = "SELECT cl.idcitaLaboratorio, cl.fecha, cl.hora, l.nombre " +
                                              "FROM citaLaboratorio cl " +
                                              "INNER JOIN laboratorio l ON cl.laboratorio_idlaboratorio = l.idlaboratorio " +
                                              "WHERE cl.cliente_idcliente = ?";
                            pstmt = conexion.prepareStatement(selectSQL);
                            pstmt.setInt(1, (Integer) session.getAttribute("idCliente"));
                            ResultSet rs = pstmt.executeQuery();

                            // Procesar los resultados y generar las opciones del select
                            while (rs.next()) {
                                int idCitaLaboratorio = rs.getInt("idcitaLaboratorio");
                                String fecha = rs.getString("fecha");
                                String hora = rs.getString("hora");
                                String nombreLaboratorio = rs.getString("nombre");
                    %>
                    <option value="<%= idCitaLaboratorio %>">
                        <%= "Fecha: " + fecha + " - Hora: " + hora + " - Laboratorio: " + nombreLaboratorio %>
                    </option>
                    <%-- Aquí se agregan las opciones de las citas con el laboratorio al formulario --%>
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
            <button type="submit" class="btn btn-danger">Eliminar Cita con el Laboratorio</button>
            <button type="button" class="btn btn-secondary" onclick="location.href='principal.jsp';">Volver</button>
        </form>
        <% 
            // Procesar el envío del formulario para eliminar la cita con el laboratorio
            if ("POST".equals(request.getMethod())) {
                int idCitaLaboratorio = Integer.parseInt(request.getParameter("citaLaboratorio_id"));
                try {
                    // Establecer la conexión
                    conexion = DriverManager.getConnection("jdbc:mysql://localhost/dbeps", "root", "123456");

                    // Eliminar la cita con el laboratorio
                    pstmt = conexion.prepareStatement("DELETE FROM citaLaboratorio WHERE idcitaLaboratorio = ?");
                    pstmt.setInt(1, idCitaLaboratorio);
                    int filasEliminadas = pstmt.executeUpdate();

                    // Mostrar mensaje de éxito
        %>
        <div class='alert alert-success mt-3'>Cita con el laboratorio eliminada exitosamente</div>
        <%
                } catch (SQLException e) {
                    e.printStackTrace();
                    // Mostrar mensaje de error
        %>
        <div class='alert alert-danger mt-3'>Error al eliminar la cita con el laboratorio</div>
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
