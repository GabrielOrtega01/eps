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
    <title>Ingresar Cita en el Laboratorio</title>
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
</head>
<body>
    <div class="container">
        <h1 class="mt-5 mb-4">Ingresar Cita en el Laboratorio</h1>
        <form action="" method="post">
            <div class="form-group">
                <label for="fecha">Fecha:</label>
                <input type="date" class="form-control" id="fecha" name="fecha" required>
            </div>
            <div class="form-group">
                <label for="hora">Hora:</label>
                <input type="time" class="form-control" id="hora" name="hora" required>
            </div>
            <div class="form-group">
                <label for="laboratorio">Seleccionar Laboratorio:</label>
                <select class="form-control" id="laboratorio" name="Laboratorio_id">
                    <% 
                        Connection conexion = null;
                        PreparedStatement pstmt = null;
                       try {
                            // Obtener el id del cliente autenticado desde la sesión
                            Integer idCliente = (Integer) session.getAttribute("idCliente");
                            if (idCliente != null) {
                                Class.forName("com.mysql.jdbc.Driver");
                                conexion = DriverManager.getConnection("jdbc:mysql://localhost/dbeps", "root", "123456");

                            // Seleccionar laboratorios
                            String selectSQL = "SELECT idLaboratorio, nombre FROM Laboratorio";
                           pstmt = conexion.prepareStatement(selectSQL);
                                ResultSet rs = pstmt.executeQuery();

                                // Procesar los resultados
                                while (rs.next()) {
                                int idLaboratorio = rs.getInt("idlaboratorio");
                                String nombreLaboratorio = rs.getString("nombre");
                    %>
                    <option value="<%= idLaboratorio %>"><%= nombreLaboratorio %></option>
                    <%-- Aquí se agregan las opciones de los laboratorios al formulario --%>
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
            <button type="submit" class="btn btn-primary">Guardar Cita en el Laboratorio</button>
            <button type="button" class="btn btn-secondary" onclick="location.href='principal.jsp';">Volver</button>
        </form>
        <% 
            // Procesar el envío del formulario
            if ("POST".equals(request.getMethod())) {
                // Obtener los datos del formulario
                String fecha = request.getParameter("fecha");
                String hora = request.getParameter("hora");
                int idLaboratorio = Integer.parseInt(request.getParameter("Laboratorio_id"));

                  // Obtener el id del cliente autenticado desde la sesión
                Integer idCliente = (Integer) session.getAttribute("idCliente");
                if (idCliente != null) {
                    try {
                        // Establecer la conexión
                        conexion = DriverManager.getConnection("jdbc:mysql://localhost/dbeps", "root", "123456");

                        // Insertar la cita en el laboratorio
                        String insertSQL = "INSERT INTO citaLaboratorio (cliente_idcliente, fecha, hora, estado, Laboratorio_idLaboratorio) VALUES (?, ?, ?, ?, ?)";
                        pstmt = conexion.prepareStatement(insertSQL);
                            pstmt.setInt(1, idCliente);
                            pstmt.setString(2, fecha);
                            pstmt.setString(3, hora);
                            pstmt.setString(4, "pendiente"); // estado
                            pstmt.setInt(5, idLaboratorio);

                            // Ejecutar la consulta
                            pstmt.executeUpdate();

                            // Mostrar mensaje de éxito
                        out.println("<div class='alert alert-success mt-3'>Cita en el laboratorio guardada exitosamente</div>");
                    } catch (SQLException e) {
                        e.printStackTrace();
                        // Mostrar mensaje de error
                        out.println("<div class='alert alert-danger mt-3'>Error: ID del laboratorio no válido</div>");
                    } finally {
                        try {
                            if (pstmt != null) pstmt.close();
                            if (conexion != null) conexion.close();
                        } catch (SQLException e) {
                            e.printStackTrace();
                        }
                    }
                } else {
                    // Mostrar mensaje de error si no hay sesión iniciada
                    out.println("<div class='alert alert-danger mt-3'>Error: No se ha iniciado sesión</div>");
                }
            }
        %>
    </div>
</body>
</html>

