    //
    //  JuegosViewController.swift
    //  ColeccionDeJuegos
    //
    //  Created by Elvis Quecara Cruz on 28/10/23.
    //

    import UIKit
    import CoreData

    class JuegosViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
        // ...

        @IBOutlet weak var imageView: UIImageView!
        @IBOutlet weak var tituloTextField: UITextField!

        @IBOutlet weak var agregarActualizarBoton: UIButton!

        @IBOutlet weak var eliminarBoton: UIButton!

        @IBOutlet weak var categoriaPicker: UIPickerView!

        var imagePicker = UIImagePickerController()
        var juego: Juego? = nil
        var categorias: [String] = ["Aventura","Estrategia","Fantasia","Carreras","Survival Horror"] // Cambia el tipo de la matriz a String
        
        

        override func viewDidLoad() {
            super.viewDidLoad()
            imagePicker.delegate = self
            categoriaPicker.delegate = self
            categoriaPicker.dataSource = self

            if juego != nil {
                imageView.image = UIImage(data: (juego!.imagen!) as Data)
                tituloTextField.text = juego!.titulo

                // Comprueba si el juego ya tiene una categoría asignada y selecciona esa categoría en el UIPickerView si es así.
                if let juegoCategoria = juego?.categoria {
                    if let selectedIndex = categorias.firstIndex(of: juegoCategoria) {
                        categoriaPicker.selectRow(selectedIndex, inComponent: 0, animated: false)
                    }
                }

                agregarActualizarBoton.setTitle("Actualizar", for: .normal)
            } else {
                eliminarBoton.isHidden = true
            }
        }

        // Implementa los métodos del protocolo UIPickerViewDataSource y UIPickerViewDelegate:

        func numberOfComponents(in pickerView: UIPickerView) -> Int {
            return 1 // Solo hay una columna en el UIPickerView
        }

        func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
            return categorias.count
        }

        func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
            return categorias[row]
        }

        func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
            // Cuando se selecciona una categoría, puedes almacenarla en una propiedad del juego si lo deseas.
            juego?.categoria = categorias[row]
        }

        // ...

        @IBAction func fotosTapped(_ sender: Any) {
            imagePicker.sourceType = .photoLibrary
            present(imagePicker, animated: true, completion: nil)
        }

        @IBAction func elminarTapped(_ sender: Any) {
            let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
            context.delete(juego!)
            (UIApplication.shared.delegate as! AppDelegate).saveContext()
            navigationController?.popViewController(animated: true)
        }

        @IBAction func camaraTapped(_ sender: Any) {
        }

        @IBAction func agregarTapped(_ sender: Any) {
            if juego != nil {
                juego!.titulo! = tituloTextField.text!
                juego!.imagen = imageView.image?.jpegData(compressionQuality: 0.50)
            } else {
                let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
                let juego = Juego(context: context)
                juego.titulo = tituloTextField.text
                juego.imagen = imageView.image?.jpegData(compressionQuality: 0.50)
                juego.categoria = categorias[categoriaPicker.selectedRow(inComponent: 0)] // Guarda la categoría seleccionada
            }

            (UIApplication.shared.delegate as! AppDelegate).saveContext()
            navigationController?.popViewController(animated: true)
        }

        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            let imagenSeleccionada = info[.originalImage] as? UIImage
            imageView.image = imagenSeleccionada
            imagePicker.dismiss(animated: true, completion: nil)
        }
    }
