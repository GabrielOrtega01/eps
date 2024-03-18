<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Mostrar Citas Médicas</title>
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
        <h1 class="mt-5 mb-4">Mostrar Citas Médicas</h1>
        <table class="table table-striped">
            <thead>
                <tr>
                    <th>Cliente</th>
                    <th>Medico</th>
                    <th>Especialidad</th>
                    <th>Fecha</th>
                    <th>Hora</th>
                    <th>Estado</th>
                </tr>
            </thead>
            <tbody>
                <% 
                    try {
                        Class.forName("com.mysql.jdbc.Driver");
                        Connection con = DriverManager.getConnection("jdbc:mysql://localhost/dbeps", "root", "123");
                        PreparedStatement pst = con.prepareStatement("SELECT cm.fecha, cm.hora, cm.estado, c.nombre AS nombre_cliente, c.apellido AS apellido_cliente, m.nombre AS nombre_medico, m.apellido AS apellido_medico, m.especialidad FROM citaMedica cm INNER JOIN cliente c ON cm.cliente_idcliente = c.idcliente INNER JOIN medico m ON cm.medico_idmedico = m.idmedico");
                        ResultSet rs = pst.executeQuery();
                                                
                        while (rs.next()) {
                            String nombreCliente = rs.getString("nombre_cliente") + " " + rs.getString("apellido_cliente");
                            String nombreMedico = rs.getString("nombre_medico") + " " + rs.getString("apellido_medico");
                            String especialidadMedico = rs.getString("especialidad");
                            String fecha = rs.getString("fecha");
                            String hora = rs.getString("hora");
                            String estado = rs.getString("estado");
                %>
                <tr>
                    <td><%= nombreCliente %></td>
                    <td><%= nombreMedico %></td>
                    <td><%= especialidadMedico %></td>
                    <td><%= fecha %></td>
                    <td><%= hora %></td>
                    <td><%= estado %></td>
                </tr>
                <% 
                        }
                        rs.close();
                        pst.close();
                        con.close();
                    } catch (ClassNotFoundException | SQLException e) {
                        e.printStackTrace();
                    }
                %>
            </tbody>
        </table>
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
