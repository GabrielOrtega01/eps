<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Eliminar Citas de Laboratorio</title>
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
        <h1 class="mt-5 mb-4">Eliminar Citas de Laboratorio</h1>
        <%-- Mensaje de éxito --%>
        <% 
            if (request.getParameter("eliminado") != null) { 
        %>
        <div class="alert alert-success" role="alert">
            La cita de laboratorio ha sido eliminada exitosamente.
        </div>
        <% 
            }
        %>
        <%-- Fin del mensaje de éxito --%>
        <table class="table table-striped">
            <thead>
                <tr>
                    <th>Cliente</th>
                    <th>Fecha</th>
                    <th>Hora</th>
                    <th>Estado</th>
                    <th>Acciones</th>
                </tr>
            </thead>
            <tbody>
                <% 
                    try {
                        Class.forName("com.mysql.jdbc.Driver");
                        Connection con = DriverManager.getConnection("jdbc:mysql://localhost/dbeps", "root", "123");
                        PreparedStatement pst = con.prepareStatement("SELECT cl.nombre AS nombre_cliente, cl.apellido AS apellido_cliente, ct.fecha, ct.hora, ct.estado, ct.idcitaLaboratorio FROM citaLaboratorio ct INNER JOIN cliente cl ON ct.cliente_idcliente = cl.idcliente");
                        ResultSet rs = pst.executeQuery();
                                                
                        while (rs.next()) {
                            String nombreCliente = rs.getString("nombre_cliente") + " " + rs.getString("apellido_cliente");
                            String fecha = rs.getString("fecha");
                            String hora = rs.getString("hora");
                            String estado = rs.getString("estado");
                            int citaId = rs.getInt("idcitaLaboratorio");
                %>
                <tr>
                    <td><%= nombreCliente %></td>
                    <td><%= fecha %></td>
                    <td><%= hora %></td>
                    <td><%= estado %></td>
                    <td>
                        <form action="" method="post">
                            <input type="hidden" name="idcitaLaboratorio" value="<%= citaId %>">
                            <button type="submit" name="eliminar" class="btn btn-danger" onclick="return confirm('¿Estás seguro de que quieres eliminar esta cita de laboratorio?')">Eliminar</button>
                        </form>
                    </td>
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
    
    <%-- Lógica para eliminar la cita de laboratorio --%>
    <% 
        if (request.getParameter("eliminar") != null) {
            int citaId = Integer.parseInt(request.getParameter("idcitaLaboratorio"));
            try {
                Class.forName("com.mysql.jdbc.Driver");
                Connection con = DriverManager.getConnection("jdbc:mysql://localhost/dbeps", "root", "123");
                PreparedStatement pst = con.prepareStatement("DELETE FROM citaLaboratorio WHERE idcitaLaboratorio = ?");
                pst.setInt(1, citaId);
                int rowsAffected = pst.executeUpdate();
                if (rowsAffected > 0) {
    %>
    <script>
        window.location.replace("eliminar_cita_laboratorio.jsp?eliminado=true");
    </script>
    <% 
                }
                pst.close();
                con.close();
            } catch (ClassNotFoundException | SQLException e) {
                e.printStackTrace();
            }
        }
    %>
    <%-- Fin de la lógica para eliminar la cita de laboratorio --%>
</body>
</html>
