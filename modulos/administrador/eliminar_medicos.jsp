<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Eliminar Médicos</title>
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
        .card {
            margin-bottom: 20px;
        }
    </style>
</head>
<body>
    <div class="container">
        <h1 class="mt-5 mb-4">Eliminar Médicos</h1>
        <%-- Mensaje de éxito --%>
        <% 
            if (request.getParameter("eliminado") != null) { 
        %>
        <div class="alert alert-success" role="alert">
            El médico ha sido eliminado exitosamente.
        </div>
        <% 
            }
        %>
        <%-- Fin del mensaje de éxito --%>
        <div class="card">
            <div class="card-body">
                <table class="table table-striped">
                    <thead>
                        <tr>
                            <th>Documento</th>
                            <th>Nombre</th>
                            <th>Apellido</th>
                            <th>Especialidad</th>
                            <th>Acciones</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% 
                            try {
                                Class.forName("com.mysql.jdbc.Driver");
                                Connection con = DriverManager.getConnection("jdbc:mysql://localhost/dbeps", "root", "123");
                                PreparedStatement pst = con.prepareStatement("SELECT idmedico, documento, nombre, apellido, especialidad FROM medico");
                                ResultSet rs = pst.executeQuery();
                                                        
                                while (rs.next()) {
                                    int idMedico = rs.getInt("idmedico");
                                    String documento = rs.getString("documento");
                                    String nombre = rs.getString("nombre");
                                    String apellido = rs.getString("apellido");
                                    String especialidad = rs.getString("especialidad");
                        %>
                        <tr>
                            <td><%= documento %></td>
                            <td><%= nombre %></td>
                            <td><%= apellido %></td>
                            <td><%= especialidad %></td>
                            <td>
                                <form action="" method="post">
                                    <input type="hidden" name="idMedico" value="<%= idMedico %>">
                                    <button type="submit" name="eliminar" class="btn btn-danger" onclick="return confirm('¿Estás seguro de que quieres eliminar este médico?')">Eliminar</button>
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
            </div>
        </div>
        <!-- Botón de Regresar -->
        <button type="button" class="btn btn-secondary" onclick="location.href='principal.jsp';">Volver</button>
        <!-- Fin del Botón de Regresar -->
    </div>

    <!-- Bootstrap JS (opcional, si necesitas funcionalidades de Bootstrap) -->
    <script src="https://code.jquery.com/jquery-3.5.1.slim.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.5.4/dist/umd/popper.min.js"></script>
    <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>
    
    <%-- Lógica para eliminar el médico --%>
    <% 
        if (request.getParameter("eliminar") != null) {
            int idMedico = Integer.parseInt(request.getParameter("idMedico"));
            try {
                Class.forName("com.mysql.jdbc.Driver");
                Connection con = DriverManager.getConnection("jdbc:mysql://localhost/dbeps", "root", "123");
                PreparedStatement pst = con.prepareStatement("DELETE FROM medico WHERE idmedico = ?");
                pst.setInt(1, idMedico);
                int rowsAffected = pst.executeUpdate();
                if (rowsAffected > 0) {
    %>
    <script>
        window.location.replace("eliminar_medicos.jsp?eliminado=true");
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
    <%-- Fin de la lógica para eliminar el médico --%>
</body>
</html>
