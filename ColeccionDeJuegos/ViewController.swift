        //
        //  ViewController.swift
        //  ColeccionDeJuegos
        //
        //  Created by Elvis Quecara Cruz on 28/10/23.
        //

        import UIKit

        class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
            
            
            @IBOutlet weak var tableView: UITableView!
            var juegos : [Juego] = []
            var ed: Bool = false

            
            @IBAction func editButtonTapped(_ sender: UIBarButtonItem) {
                ed = !ed
                tableView.isEditing = ed
                sender.title = ed ? "Done" : "Edit" // Cambia el título del botón según el estado
            }

            override func viewDidLoad() {
                super.viewDidLoad()
                tableView.dataSource = self
                tableView.delegate = self
                tableView.isEditing = ed
                
            }
            
            override func viewWillAppear(_ animated: Bool) {
                let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
                do{
                    try juegos = context.fetch(Juego.fetchRequest())
                    tableView.reloadData()
                }catch{
                    
                }
            }
            
            override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
                let siguienteVC = segue.destination as! JuegosViewController
                siguienteVC.juego = sender as? Juego
            }
            
            func toggleEditing() {
                isEditing = !isEditing
                tableView.isEditing = isEditing
                tableView.reloadData()
            }

            
            
            func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
                return juegos.count
            }
            
            func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
                let cell = UITableViewCell()
                let juego  = juegos[indexPath.row]
                cell.textLabel?.text = "\(juego.titulo ?? "") - \(juego.categoria ?? "")"
                
                
                
                   
                   
                cell.imageView?.image = UIImage(data: (juego.imagen ?? Data()))
                return cell
            }
            
            
            func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
                let juego = juegos[indexPath.row]
                performSegue(withIdentifier: "juegoSegue", sender: juego)
            }

            
            func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
                if editingStyle == .delete {
                    let juego = juegos[indexPath.row]
                    
                    // Elimina el juego de la fuente de datos
                    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
                    context.delete(juego)
                    
                    do {
                        try context.save()
                        juegos.remove(at: indexPath.row)
                        tableView.deleteRows(at: [indexPath], with: .fade)
                    } catch {
                        // Manejar errores
                    }
                }
            }

            func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
                let juegoToMove = juegos[sourceIndexPath.row]
                juegos.remove(at: sourceIndexPath.row)
                juegos.insert(juegoToMove, at: destinationIndexPath.row)
            }

            
        }
            



