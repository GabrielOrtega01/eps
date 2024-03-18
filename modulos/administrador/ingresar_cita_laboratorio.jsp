<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Ingresar Cita Laboratorio</title>
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
        <h1 class="mt-5 mb-4">Ingresar Cita Laboratorio</h1>
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
                <label for="laboratorio">Seleccionar Laboratorio:</label>
                <select class="form-control" id="laboratorio" name="laboratorio_id">
                    <% 
                        try {
                            Class.forName("com.mysql.jdbc.Driver");
                            Connection con = DriverManager.getConnection("jdbc:mysql://localhost/dbeps", "root", "123");
                            PreparedStatement pst = con.prepareStatement("SELECT idLaboratorio, nombre FROM Laboratorio");
                            ResultSet rs = pst.executeQuery();
                            while (rs.next()) {
                                int idLaboratorio = rs.getInt("idLaboratorio");
                                String nombreLaboratorio = rs.getString("nombre");
                    %>
                    <option value="<%= idLaboratorio %>"><%= nombreLaboratorio %></option>
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
            <button type="submit" class="btn btn-primary">Guardar Cita Laboratorio</button>
        </form>
        
        <!-- Mensaje de éxito -->
        <% 
            if ("POST".equals(request.getMethod())) {
                String fecha = request.getParameter("fecha");
                String hora = request.getParameter("hora");
                int idCliente = Integer.parseInt(request.getParameter("cliente_id"));
                int idLaboratorio = Integer.parseInt(request.getParameter("laboratorio_id"));
                
                try {
                    Class.forName("com.mysql.jdbc.Driver");
                    Connection con = DriverManager.getConnection("jdbc:mysql://localhost/dbeps", "root", "123");
                    PreparedStatement pst = con.prepareStatement("INSERT INTO citaLaboratorio (cliente_idcliente, fecha, hora, estado, Laboratorio_idLaboratorio) VALUES (?, ?, ?, ?, ?)");
                    pst.setInt(1, idCliente);
                    pst.setString(2, fecha);
                    pst.setString(3, hora);
                    pst.setString(4, "pendiente");
                    pst.setInt(5, idLaboratorio);
                    pst.executeUpdate();
        %>
        <div class="alert alert-success mt-3" role="alert">
            Cita laboratorio guardada exitosamente.
        </div>
        <% 
                    pst.close();
                    con.close();
                } catch (ClassNotFoundException | SQLException e) {
                    e.printStackTrace();
        %>
        <div class="alert alert-danger mt-3" role="alert">
            Error al guardar la cita laboratorio. Por favor, inténtelo de nuevo.
        </div>
        <% 
                }
            }
        %>
        <!-- Fin del mensaje de éxito -->
        
        <!-- Botón de Regresar -->
        <button type="button" class="btn btn-secondary mt-3" onclick="location.href='principal.jsp';">Volver</button>
        <!-- Fin del Botón de Regresar -->
    </div>

    <!-- Bootstrap JS (opcional, si necesitas funcionalidades de Bootstrap) -->
    <script src="https://code.jquery.com/jquery-3.5.1.slim.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.5.4/dist/umd/popper.min.js"></script>
    <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>
</body>
</html>
