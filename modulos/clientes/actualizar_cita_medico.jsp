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
    <title>Actualizar Cita con el Médico</title>
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
</head>
<body>
    <div class="container">
        <h1 class="mt-5 mb-4">Actualizar Cita con el Médico</h1>

        <form action="" method="post">
            <div class="form-group">
                <label for="citaMedica">Seleccionar cita:</label>
                <select class="form-control" id="citaMedica" name="citaMedica_id">
                    <% 
                        Connection conexion = null;
                        PreparedStatement pstmt = null;
                        try {
                            // Obtener el id del cliente autenticado desde la sesión
                            Integer idCliente = (Integer) session.getAttribute("idCliente");
                            if (idCliente != null) {
                                Class.forName("com.mysql.jdbc.Driver");
                                conexion = DriverManager.getConnection("jdbc:mysql://localhost/dbeps", "root", "123456");

                                // Seleccionar citas médicas del cliente actual
                                String selectSQL = "SELECT idcitaMedica, CONCAT(m.nombre, ' ', m.apellido) AS medico_nombre, m.especialidad " +
                                    "FROM citamedica cm " +
                                    "INNER JOIN medico m ON cm.medico_idmedico = m.idmedico " +
                                    "WHERE cm.cliente_idcliente = ?";
                                pstmt = conexion.prepareStatement(selectSQL);
                                pstmt.setInt(1, idCliente);
                                ResultSet rs = pstmt.executeQuery();

                                // Procesar los resultados
                                while (rs.next()) {
                                    int idCita = rs.getInt("idcitaMedica");
                                    String nombreMedico = rs.getString("medico_nombre");
                                    String especialidadMedico = rs.getString("especialidad");
                    %>
                    <option value="<%= idCita %>"><%= nombreMedico %> - <%= especialidadMedico %></option>
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
                <label for="medico">Seleccionar Médico:</label>
                <select class="form-control" id="medico" name="medico_id">
                    <% 
                        // Reutilizar la conexión ya definida arriba
                        pstmt = null;
                        try {
                            Class.forName("com.mysql.jdbc.Driver");
                            conexion = DriverManager.getConnection("jdbc:mysql://localhost/dbeps", "root", "123456");

                            // Seleccionar médicos
                            String selectSQL = "SELECT idmedico, CONCAT(nombre, ' ', apellido) AS nombre, especialidad FROM medico";
                            pstmt = conexion.prepareStatement(selectSQL);
                            ResultSet rs = pstmt.executeQuery();

                            // Procesar los resultados
                            while (rs.next()) {
                                int idMedico = rs.getInt("idmedico");
                                String nombreMedico = rs.getString("nombre");
                                String especialidadMedico = rs.getString("especialidad");
                    %>
                    <option value="<%= idMedico %>"><%= nombreMedico %> - <%= especialidadMedico %></option>
                    <%-- Aquí se agregan las opciones de los médicos al formulario --%>
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
            <button type="submit" class="btn btn-primary">Guardar Cita Médica</button>
            <button type="button" class="btn btn-secondary" onclick="location.href='principal.jsp';">Volver</button>
        </form>

        <% 
            // Procesar el envío del formulario
            if ("POST".equals(request.getMethod())) {
                // Obtener los datos del formulario
                String fecha = request.getParameter("fecha");
                String hora = request.getParameter("hora");
                int idMedico = Integer.parseInt(request.getParameter("medico_id"));
                int idCita = Integer.parseInt(request.getParameter("citaMedica_id"));
                
                // Obtener el id del cliente autenticado desde la sesión
                Integer idCliente = (Integer) session.getAttribute("idCliente");
                if (idCliente != null) {
                    try {
                        // Establecer la conexión
                        conexion = DriverManager.getConnection("jdbc:mysql://localhost/dbeps", "root", "123456");

                        // Actualizar la cita médica
                        String updateSQL = "UPDATE citamedica SET medico_idmedico = ?, fecha = ?, hora = ? WHERE idcitaMedica = ? AND cliente_idcliente = ?";
                        pstmt = conexion.prepareStatement(updateSQL);
                        pstmt.setInt(1, idMedico);
                        pstmt.setString(2, fecha);
                        pstmt.setString(3, hora);
                        pstmt.setInt(4, idCita);
                        pstmt.setInt(5, idCliente);

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
