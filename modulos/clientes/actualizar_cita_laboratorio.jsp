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
    <title>Actualizar Cita con el Laboratorio</title>
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
</head>
<body>
    <div class="container">
        <h1 class="mt-5 mb-4">Actualizar Cita con el Laboratorio</h1>

        <form action="" method="post">
            <div class="form-group">
                <label for="citaLaboratorio">Seleccionar cita:</label>
                <select class="form-control" id="citaLaboratorio" name="citaLaboratorio_id">
                    <% 
                        Connection conexion = null;
                        PreparedStatement pstmt = null;
                        try {
                            // Obtener el id del cliente autenticado desde la sesión
                            Integer idCliente = (Integer) session.getAttribute("idCliente");
                            if (idCliente != null) {
                                Class.forName("com.mysql.jdbc.Driver");
                                conexion = DriverManager.getConnection("jdbc:mysql://localhost/dbeps", "root", "123");

                                // Seleccionar citas con el laboratorio del cliente actual
                                String selectSQL = "SELECT cl.idcitaLaboratorio, l.nombre AS nombreLaboratorio, cl.fecha, cl.hora " +
                                                   "FROM citaLaboratorio cl " +
                                                   "INNER JOIN cliente c ON cl.cliente_idcliente = c.idcliente " +
                                                   "INNER JOIN laboratorio l ON cl.laboratorio_idlaboratorio = l.idlaboratorio " +
                                                   "WHERE cl.cliente_idcliente = ?";
                                pstmt = conexion.prepareStatement(selectSQL);
                                pstmt.setInt(1, idCliente);
                                ResultSet rs = pstmt.executeQuery();

                                // Procesar los resultados
                                while (rs.next()) {
                                    int idCita = rs.getInt("idcitaLaboratorio");
                                    String nombreLaboratorio = rs.getString("nombreLaboratorio");
                                    String fecha = rs.getString("fecha");
                                    String hora = rs.getString("hora");
                    %>
                    <option value="<%= idCita %>"><%= nombreLaboratorio %> - <%= fecha %> - <%= hora %></option>
                    <%-- Aquí se agregan las opciones de las citas con el laboratorio al formulario --%>
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
                <label for="fecha">Nueva Fecha:</label>
                <input type="date" class="form-control" id="fecha" name="fecha" required>
            </div>
            <div class="form-group">
                <label for="hora">Nueva Hora:</label>
                <input type="time" class="form-control" id="hora" name="hora" required>
            </div>
            <button type="submit" class="btn btn-primary">Guardar Cambios</button>
            <button type="button" class="btn btn-secondary" onclick="location.href='principal.jsp';">Volver</button>
        </form>

        <% 
            // Procesar el envío del formulario
            if ("POST".equals(request.getMethod())) {
                // Obtener los datos del formulario
                String fecha = request.getParameter("fecha");
                String hora = request.getParameter("hora");
                int idCita = Integer.parseInt(request.getParameter("citaLaboratorio_id"));
                
                // Obtener el id del cliente autenticado desde la sesión
                Integer idCliente = (Integer) session.getAttribute("idCliente");
                if (idCliente != null) {
                    try {
                        // Establecer la conexión
                        conexion = DriverManager.getConnection("jdbc:mysql://localhost/dbeps", "root", "123");

                        // Actualizar la cita con el laboratorio
                        String updateSQL = "UPDATE citaLaboratorio SET fecha = ?, hora = ? WHERE idcitaLaboratorio = ? AND cliente_idcliente = ?";
                        pstmt = conexion.prepareStatement(updateSQL);
                        pstmt.setString(1, fecha);
                        pstmt.setString(2, hora);
                        pstmt.setInt(3, idCita);
                        pstmt.setInt(4, idCliente);

                        // Ejecutar la consulta
                        int rowsAffected = pstmt.executeUpdate();

                        // Verificar si se actualizó correctamente
                        if (rowsAffected > 0) {
        %>
        <div class="alert alert-success mt-3">Cita con el laboratorio actualizada exitosamente</div>
        <%          } else { %>
        <div class="alert alert-danger mt-3">Error al actualizar la cita con el laboratorio</div>
        <%          }
                    } catch (SQLException e) {
                        e.printStackTrace();
                        // Mostrar mensaje de error
        %>
        <div class="alert alert-danger mt-3">Error al actualizar la cita con el laboratorio</div>
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
