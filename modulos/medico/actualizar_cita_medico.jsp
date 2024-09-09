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
    <title>Actualizar Cita Médica</title>
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
</head>
<body>
    <div class="container">
        <h1 class="mt-5 mb-4">Actualizar Cita Médica</h1>

        <form action="" method="post">
            <div class="form-group">
                <label for="citaMedica">Seleccionar cita:</label>
                <select class="form-control" id="citaMedica" name="citaMedica_id">
                    <% 
                        Connection conexion = null;
                        PreparedStatement pstmt = null;
                        try {
                            // Obtener el id del médico autenticado desde la sesión
                            Integer idMedico = (Integer) session.getAttribute("idMedico");
                            if (idMedico != null) {
                                Class.forName("com.mysql.jdbc.Driver");
                                conexion = DriverManager.getConnection("jdbc:mysql://localhost/dbeps", "root", "123456");

                                // Seleccionar citas médicas del médico actual
                                String selectSQL = "SELECT idcitaMedica, CONCAT(c.nombre, ' ', c.apellido) AS cliente_nombre, c.documento, cm.fecha, cm.hora, cm.estado " +
                                    "FROM citamedica cm " +
                                    "INNER JOIN cliente c ON cm.cliente_idcliente = c.idcliente " +
                                    "WHERE cm.medico_idmedico = ?";
                                pstmt = conexion.prepareStatement(selectSQL);
                                pstmt.setInt(1, idMedico);
                                ResultSet rs = pstmt.executeQuery();

                                // Procesar los resultados
                                while (rs.next()) {
                                    int idCita = rs.getInt("idcitaMedica");
                                    String nombreCliente = rs.getString("cliente_nombre");
                                    String documentoCliente = rs.getString("documento");
                                    String fecha = rs.getString("fecha");
                                    String hora = rs.getString("hora");
                                    String estado = rs.getString("estado");
                    %>
                    <option value="<%= idCita %>"><%= nombreCliente %> - <%= documentoCliente %> - <%= fecha %> - <%= hora %> - <%= estado %></option>
                    <%-- Aquí se agregan las opciones de las citas médicas al formulario --%>
                    <%
                                }
                            } else {
                                // Mostrar mensaje de error si no hay sesión iniciada
                                out.println("<option value=''>Error: No se ha iniciado sesión</option>");
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
            <div class="form-group">
                <label for="fecha">Fecha:</label>
                <input type="date" class="form-control" id="fecha" name="fecha" required>
            </div>
            <div class="form-group">
                <label for="hora">Hora:</label>
                <input type="time" class="form-control" id="hora" name="hora" required>
            </div>
            <div class="form-group">
                <label for="estado">Estado:</label>
                <select class="form-control" id="estado" name="estado" required>
                    <option value="pendiente">Pendiente</option>
                    <option value="aprobado">Aprobado</option>
                    <option value="cancelado">Cancelado</option>
                </select>
            </div>
            <button type="submit" class="btn btn-primary">Guardar Cita Médica</button>
            <button type="button" class="btn btn-secondary" onclick="location.href='principal.jsp';">Volver</button>
        </form>

        <% 
            // Procesar el envío del formulario
            if ("POST".equals(request.getMethod())) {
                // Obtener los datos del formulario
                String fecha = request.getParameter("fecha");
                String hora = request.getParameter("hora");
                String estado = request.getParameter("estado");
                int idCita = Integer.parseInt(request.getParameter("citaMedica_id"));
                
                // Obtener el id del médico autenticado desde la sesión
                Integer idMedico = (Integer) session.getAttribute("idMedico");
                if (idMedico != null) {
                    try {
                        // Establecer la conexión
                        conexion = DriverManager.getConnection("jdbc:mysql://localhost/dbeps", "root", "123456");

                        // Actualizar la cita médica
                        String updateSQL = "UPDATE citaMedica SET fecha = ?, hora = ?, estado = ? WHERE idcitaMedica = ? AND medico_idmedico = ?";
                        pstmt = conexion.prepareStatement(updateSQL);
                        pstmt.setString(1, fecha);
                        pstmt.setString(2, hora);
                        pstmt.setString(3, estado);
                        pstmt.setInt(4, idCita);
                        pstmt.setInt(5, idMedico);

                        // Ejecutar la consulta
                        int rowsAffected = pstmt.executeUpdate();

                        // Verificar si se actualizó correctamente
                        if (rowsAffected > 0) {
        %>
        <div class="alert alert-success mt-3">Cita médica actualizada exitosamente</div>
        <%          } else { %>
        <div class="alert alert-danger mt-3">Error al actualizar la cita médica</div>
        <%          }
                    } catch (SQLException e) {
                        e.printStackTrace();
                        // Mostrar mensaje de error
        %>
        <div class="alert alert-danger mt-3">Error al actualizar la cita médica</div>
        <%          }
                    finally {
                        try {
                            if (pstmt != null) pstmt.close();
                            if (conexion != null) conexion.close();
                        } catch (SQLException e) {
                            e.printStackTrace();
                        }
                    }
                } else {
                    // Mostrar mensaje de error si no hay sesión iniciada
        %>
        <div class="alert alert-danger mt-3">Error: No se ha iniciado sesión</div>
        <%      }
            }
        %>
    </div>
</body>
</html>
