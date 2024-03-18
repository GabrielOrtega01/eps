<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Actualizar Cita Médica</title>
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
        <h1 class="mt-5 mb-4">Actualizar Cita Médica</h1>
        <form action="" method="post">
            <div class="form-group">
                <label for="cliente">Seleccionar Cliente:</label>
                <select class="form-control" id="cliente" name="cliente_id">
                    <% 
                        try {
                            Class.forName("com.mysql.jdbc.Driver");
                            Connection con = DriverManager.getConnection("jdbc:mysql://localhost/dbeps", "root", "123");
                            PreparedStatement pst = con.prepareStatement("SELECT idcliente, CONCAT(nombre, ' ', apellido) AS nombre_completo FROM cliente");
                            ResultSet rs = pst.executeQuery();
                            while (rs.next()) {
                                int idCliente = rs.getInt("idcliente");
                                String nombreCliente = rs.getString("nombre_completo");
                    %>
                    <option value="<%= idCliente %>"><%= nombreCliente %></option>
                    <% 
                            }
                            rs.close();
                            pst.close();
                            con.close();
                        } catch (ClassNotFoundException | SQLException e) {
                            e.printStackTrace();
                        }
                    %>
                </select>
            </div>
            <div class="form-group">
                <label for="medico">Seleccionar Nuevo Médico:</label>
                <select class="form-control" id="medico" name="medico_id">
                    <% 
                        try {
                            Class.forName("com.mysql.jdbc.Driver");
                            Connection con = DriverManager.getConnection("jdbc:mysql://localhost/dbeps", "root", "123");
                            PreparedStatement pst = con.prepareStatement("SELECT idmedico, CONCAT(nombre, ' ', apellido) AS nombre_completo FROM medico");
                            ResultSet rs = pst.executeQuery();
                            while (rs.next()) {
                                int idMedico = rs.getInt("idmedico");
                                String nombreMedico = rs.getString("nombre_completo");
                    %>
                    <option value="<%= idMedico %>"><%= nombreMedico %></option>
                    <% 
                            }
                            rs.close();
                            pst.close();
                            con.close();
                        } catch (ClassNotFoundException | SQLException e) {
                            e.printStackTrace();
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
            <div class="form-group">
                <label for="estado">Nuevo Estado:</label>
                <select class="form-control" id="estado" name="estado">
                    <option value="pendiente">Pendiente</option>
                    <option value="cancelada">Cancelada</option>
                    <option value="realizada">Realizada</option>
                </select>
            </div>
            <button type="submit" class="btn btn-primary">Actualizar Cita Médica</button>
        </form>
        
        <% 
            if ("POST".equals(request.getMethod())) {
                int idCliente = Integer.parseInt(request.getParameter("cliente_id"));
                int idMedico = Integer.parseInt(request.getParameter("medico_id"));
                String fecha = request.getParameter("fecha");
                String hora = request.getParameter("hora");
                String estado = request.getParameter("estado");
                try {
                    Class.forName("com.mysql.jdbc.Driver");
                    Connection con = DriverManager.getConnection("jdbc:mysql://localhost/dbeps", "root", "123");
                    PreparedStatement pst = con.prepareStatement("UPDATE citaMedica SET medico_idmedico = ?, fecha = ?, hora = ?, estado = ? WHERE cliente_idcliente = ?");
                    pst.setInt(1, idMedico);
                    pst.setString(2, fecha);
                    pst.setString(3, hora);
                    pst.setString(4, estado);
                    pst.setInt(5, idCliente);
                    int rowsAffected = pst.executeUpdate();
                    if (rowsAffected > 0) {
        %>
        <div class="alert alert-success mt-3" role="alert">
            Cita médica actualizada exitosamente.
        </div>
        <% 
                    } else {
        %>
        <div class="alert alert-danger mt-3" role="alert">
            Error al actualizar la cita médica.
        </div>
        <% 
                    }
                    pst.close();
                    con.close();
                } catch (ClassNotFoundException | SQLException e) {
                    e.printStackTrace();
                }
            }
        %>
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
