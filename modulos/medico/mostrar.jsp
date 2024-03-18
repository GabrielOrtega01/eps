<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.Connection" %>
<%@ page import="java.sql.PreparedStatement" %>
<%@ page import="java.sql.DriverManager" %>
<%@ page import="java.sql.ResultSet" %>
<%@ page import="java.sql.SQLException" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Consulta de Médico</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/twitter-bootstrap/4.6.0/css/bootstrap.min.css">
</head>
<body>
    <div class="container">
        <h1>Consulta de Médico</h1>
        <table class="table table-bordered">
            <thead class="thead-dark">
                <tr>
                    <th scope="col">Documento</th>
                    <th scope="col">Nombre</th>
                    <th scope="col">Apellido</th>
                    <th scope="col">Especialidad</th>
                </tr>
            </thead>
            <tbody>
                <% // Java code for database connection and data retrieval
                    Integer idMedico = (Integer) session.getAttribute("idMedico");
                    if (idMedico != null) {
                        Connection conexion = null;
                        PreparedStatement pstmt = null;
                        ResultSet rs = null;

                        try {
                            Class.forName("com.mysql.jdbc.Driver");
                            conexion = DriverManager.getConnection("jdbc:mysql://localhost/dbeps", "root", "123");

                            String consultaSQL = "SELECT documento, nombre, apellido, especialidad FROM medico WHERE idmedico = ?";
                            pstmt = conexion.prepareStatement(consultaSQL);
                            pstmt.setInt(1, idMedico);
                            rs = pstmt.executeQuery();

                            while (rs.next()) {
                                out.println("<tr>");
                                out.println("<td>" + rs.getString("documento") + "</td>");
                                out.println("<td>" + rs.getString("nombre") + "</td>");
                                out.println("<td>" + rs.getString("apellido") + "</td>");
                                out.println("<td>" + rs.getString("especialidad") + "</td>");
                                out.println("</tr>");
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
                    } else {
                        // Handle case where idMedico is not in session
                        out.println("<tr><td colspan='4'>Error: No se ha iniciado sesión o falta el identificador del médico.</td></tr>");
                    }
                %>
            </tbody>
        </table>
        <div class="option">
            <a href="javascript:history.go(-1);" class="btn btn-primary">Regresar</a>
        </div>
    </div>
</body>
</html>
