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
    <title>Ingresar Cita con el Médico</title>
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
    <style>
        body {
            background-color: #f8f9fa;
        }
        .container {
            margin-top: 50px;
        }
        h1 {
            text-align: center;
            margin-bottom: 30px;
        }
    </style>
</head>
<body>
    <div class="container">
        <h1 class="mt-5 mb-4">Ingresar Cita con el Médico</h1>
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
                <label for="cliente">Seleccionar Cliente:</label>
                <select class="form-control" id="cliente" name="cliente_id">
                    <% 
                        Connection conexion = null;
                        PreparedStatement pstmt = null;
                        ResultSet rs = null;
                        try {
                            Class.forName("com.mysql.jdbc.Driver");
                            conexion = DriverManager.getConnection("jdbc:mysql://localhost/dbeps", "root", "123");

                            String selectSQL = "SELECT idcliente, CONCAT(nombre, ' ', apellido) AS nombre_completo FROM cliente";
                            pstmt = conexion.prepareStatement(selectSQL);
                            rs = pstmt.executeQuery();

                            while (rs.next()) {
                                int idCliente = rs.getInt("idcliente");
                                String nombreCliente = rs.getString("nombre_completo");
                    %>
                    <option value="<%= idCliente %>"><%= nombreCliente %></option>
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
                    %>
                </select>
            </div>
            <div class="form-group">
                <label for="medico">Seleccionar Médico:</label>
                <select class="form-control" id="medico" name="medico_id">
                    <!-- Lógica para mostrar la lista de médicos -->
                    <% 
                        conexion = null;
                        pstmt = null;
                        rs = null;
                        try {
                            Class.forName("com.mysql.jdbc.Driver");
                            conexion = DriverManager.getConnection("jdbc:mysql://localhost/dbeps", "root", "123");
                            
                            String selectSQL = "SELECT idmedico, CONCAT(nombre, ' ', apellido) AS nombre_completo, especialidad FROM medico";
                            pstmt = conexion.prepareStatement(selectSQL);
                            rs = pstmt.executeQuery();
                            
                            while (rs.next()) {
                    %>
                    <option value="<%= rs.getInt("idmedico") %>"><%= rs.getString("nombre_completo") %> - <%= rs.getString("especialidad") %></option>
                    <% 
                            }
                        } catch (ClassNotFoundException | SQLException e) {
                            e.printStackTrace();
                        } finally {
                            try {
                                if (rs != null) rs.close();
                                if (pstmt != null) pstmt.close();
                            } catch (SQLException e) {
                                e.printStackTrace();
                            }
                        }
                    %>
                </select>
            </div>
            <button type="submit" class="btn btn-primary">Guardar Cita Médica</button>
        </form>
        
        <!-- Mensaje de éxito -->
        <% 
            // Procesar el envío del formulario
            if ("POST".equals(request.getMethod())) {
                // Obtener los datos del formulario
                String fecha = request.getParameter("fecha");
                String hora = request.getParameter("hora");
                int idMedico = Integer.parseInt(request.getParameter("medico_id"));
                int idCliente = Integer.parseInt(request.getParameter("cliente_id"));
                
                try {
                    conexion = DriverManager.getConnection("jdbc:mysql://localhost/dbeps", "root", "123");
                    pstmt = conexion.prepareStatement("INSERT INTO citaMedica (cliente_idcliente, medico_idmedico, fecha, hora, estado) VALUES (?, ?, ?, ?, ?)");
                    pstmt.setInt(1, idCliente);
                    pstmt.setInt(2, idMedico);
                    pstmt.setString(3, fecha);
                    pstmt.setString(4, hora);
                    pstmt.setString(5, "pendiente");
                    pstmt.executeUpdate();
        %>
        <div class="alert alert-success mt-3" role="alert">
            Cita médica guardada exitosamente.
        </div>
        <% 
                } catch (SQLException e) {
                    e.printStackTrace();
        %>
        <div class="alert alert-danger mt-3" role="alert">
            Error al guardar la cita médica.
        </div>
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
        <!-- Fin del mensaje de éxito -->

        <!-- Botón de Regresar -->
        <button type="button" class="btn btn-secondary" onclick="location.href='principal.jsp';">Volver</button>
        <!-- Fin del Botón de Regresar -->
    </div>

    <!-- Bootstrap JS (opcional, si necesitas funcionalidades de Bootstrap) -->
    <script src="https://code.jquery.com/jquery-3.5.1.slim.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.5.4/dist/umd/popper.min.js"></script>
    <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>
</body>
</html>
