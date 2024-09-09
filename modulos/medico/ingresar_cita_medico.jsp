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
    <title>Ingresar Cita Médica</title>
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
</head>
<body>
    <div class="container">
        <h1 class="mt-5 mb-4">Ingresar Cita Médica</h1>

        <form action="" method="post">
            <div class="form-group">
                <label for="cliente">Seleccionar Cliente:</label>
                <select class="form-control" id="cliente" name="cliente_id">
                    <% 
                        Connection conexion = null;
                        PreparedStatement pstmt = null;
                        try {
                            // Obtener el id del médico autenticado desde la sesión
                            Integer idMedico = (Integer) session.getAttribute("idMedico");
                            if (idMedico != null) {
                                Class.forName("com.mysql.jdbc.Driver");
                                conexion = DriverManager.getConnection("jdbc:mysql://localhost/dbeps", "root", "123456");

                                // Seleccionar clientes
                                String selectSQL = "SELECT idcliente, CONCAT(nombre, ' ', apellido) AS nombre_cliente, documento FROM cliente";
                                pstmt = conexion.prepareStatement(selectSQL);
                                ResultSet rs = pstmt.executeQuery();

                                // Procesar los resultados
                                while (rs.next()) {
                                    int idCliente = rs.getInt("idcliente");
                                    String nombreCliente = rs.getString("nombre_cliente");
                                    String documentoCliente = rs.getString("documento");
                    %>
                    <option value="<%= idCliente %>"><%= nombreCliente %> - <%= documentoCliente %></option>
                    <%-- Aquí se agregan las opciones de los clientes al formulario --%>
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
                int idCliente = Integer.parseInt(request.getParameter("cliente_id"));
                
                // Obtener el id del médico autenticado desde la sesión
                Integer idMedico = (Integer) session.getAttribute("idMedico");
                if (idMedico != null) {
                    try {
                        // Establecer la conexión
                        conexion = DriverManager.getConnection("jdbc:mysql://localhost/dbeps", "root", "123456");

                        // Insertar la nueva cita médica
                        String insertSQL = "INSERT INTO citamedica (cliente_idcliente, medico_idmedico, fecha, hora, estado) VALUES (?, ?, ?, ?, ?)";
                        pstmt = conexion.prepareStatement(insertSQL);
                        pstmt.setInt(1, idCliente);
                        pstmt.setInt(2, idMedico);
                        pstmt.setString(3, fecha);
                        pstmt.setString(4, hora);
                        pstmt.setString(5, estado);

                        // Ejecutar la consulta
                        int rowsAffected = pstmt.executeUpdate();

                        // Verificar si se insertó correctamente
                        if (rowsAffected > 0) {
        %>
        <div class="alert alert-success mt-3">Cita médica ingresada exitosamente</div>
        <%          } else { %>
        <div class="alert alert-danger mt-3">Error al ingresar la cita médica</div>
        <%          }
                    } catch (SQLException e) {
                        e.printStackTrace();
                        // Mostrar mensaje de error
        %>
        <div class="alert alert-danger mt-3">Error al ingresar la cita médica</div>
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
