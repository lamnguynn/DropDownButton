//
//  DropDown.swift
//  DropDownButton
//
//  Created by Lam Nguyen on 8/12/21.
//
//
//  KNOWN ISSUES:
//  - (DropDownMenu) Font of a cell in the table will resize when too small, and leave the fonts of all the cells feeling unbalanced. Temp solution is just change the font size manually via the dropDownTextSize property.
//  - (DropDownButton) Animation could still be perfected to be more smooth
//
//  VERSION: 1.0
//
//

import UIKit

//----------------------------
//----------------------------
// MARK: protocol
//----------------------------
//----------------------------

/**
        This protocol delegates to an object the string of whatever item is clicked in the drop-down menu.
 */
private protocol dropDownProtocol : AnyObject{
    func dropDownClicked(string: String)
}
/**
        This protocol delegates to an object the indexPath of whatever item is clicked in the drop-down menu.
 */
public protocol dropDownIndexPath : AnyObject {
    func dropDownClicked(indexPath: IndexPath)
}


//----------------------------
//----------------------------
// MARK: drop down button
//----------------------------
//----------------------------

/**
        An object that allows for a drop-down functionality for a button
 */
public class DropDownButton: UIButton, dropDownProtocol{
    
    //----------------------------
    //----------------------------
    // MARK: asset initialization
    //----------------------------
    //----------------------------
    
    /**
            Height of the drop-down menu.
     
            By default, the height is 150, but can be changed here.
     */
    open var heightOfDropDown: CGFloat = 150                            //Height of the drop down
    
    /**
            Data in the form of a list of strings to present in the drop-down menu.
     
            By default, there is no data to present. If there is none, then the button is does not change or show animations.
    */
    open var dataSource: [String] = [String]()                          //Data to present
    
    /**
            Color of the drop-down menu.
         
            By default, the background color is white, but can be changed here.
     */
    open var dropDownColor: UIColor? = .white                           //Color of the drop down
    
    /**
            Text color of the drop-down menu.
            
            By default, the text color is gray, but can be changed here
     */
    open var dropDownTextColor: UIColor? = .gray
    
    /**
            Corner radius of the drop-down menu
                
            By default, the corner radius is 12, but can be changed. To change the corner radius of the button, you can directly do so by calling `cornerRadius` property of the it.
     */
    open var dropDownCornerRadius: CGFloat? = 12
    
    /**
            Text size of the drop-down menu

            By default, the text size if 18, but can be changed here
     */
    open var dropDownTextSize: CGFloat? = 18
    
    ///Animation time for showing the drop-down menu.
    open var showMenuAnimationSpeed: Double = 0.45
    
    ///Animation delay for showing the drop-down menu.
    open var showMenuAnimationDelay: Double = 0.3
    
    ///Animation for the springs oscillation for showing the drop-down menu. Employ a value closer to zero to increase oscillation. To smoothly decelerate the animation without oscillation, use a value of 1.
    open var showMenuAnimationUsingSpringWithDamping: CGFloat = 0.5
    
    ///Animation for the initial spring velocity for the showing the drop-down menu. Employ a value higher will give the spring more initial momentum.
    open var showMenuAnimationInitialSpringVelocity: CGFloat = 0.3
    
    ///Animation time for hiding the drop-down menu.
    open var hideMenuAnimationDelay: Double = 0.3
    
    ///Animation delay for hiding the drop-down menu.
    open var hideMenuAnimationSpeed: Double = 0.5
    
    ///Animation for the springs oscillation for hiding the drop-down menu. Employ a value closer to zero to increase oscillation. To smoothly decelerate the animation without oscillation, use a value of 1.
    open var hideMenuAnimationUsingSpringWithDamping: CGFloat = 0.85
    
    ///Animation for the initial spring velocity for the hiding the drop-down menu. Employ a value higher will give the spring more initial momentum.
    open var hideMenuAnimationInitialSpringVelocity: CGFloat = 0.5
    
    ///Height constraint of the drop down
    private var height: NSLayoutConstraint = NSLayoutConstraint()
    
    ///Variable to store if the drop down is open
    private var isOpen: Bool = false
    
    ///Variable to store if the drop-down will be out of bounds. Done to adjust whether the drop-down will go up or down.
    private var isOutOfBounds: Bool = false
    
    ///Drop-down menu
    private var dropView : DropDownMenu?
    
    //----------------------------
    //----------------------------
    // MARK: init and set up for view
    //----------------------------
    //----------------------------
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        //Set up the drop down
        dropView = DropDownMenu.init(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        dropView?.translatesAutoresizingMaskIntoConstraints = false
        dropView?.InternalDelegate = self
        self.layer.cornerRadius = 12                                                                //Set the default value for the corner radius of the button.
    }
    
    required init(coder aDecode: NSCoder){
        fatalError("Error")
    }
    
    /*
        @convenience init
        - coverButton: whether to cover the button when drop down appears
        - dataSource: data source to display
        - heightOfDropDown: height of the drop down
     */
    public convenience init(dataSource: [String], heightOfDropDown: CGFloat = 150, dropDownCornerRadius: CGFloat = 12){
        self.init(frame: .zero)
        self.heightOfDropDown = heightOfDropDown
        self.dataSource = dataSource
        self.dropView?.dataSource = dataSource
        self.dropDownCornerRadius = dropDownCornerRadius
    }
    
    /*
        @didMoveToSuperview
        Wait until superview is loaded to add to constraints
     */
    public override func didMoveToSuperview() {
        if let superview = self.superview{
            superview.addSubview(dropView!)
            superview.bringSubviewToFront(dropView!)
            
            dropView?.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true                             //Center the view horzontally
            dropView?.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true                                 //Set the width to the width of the button
            height = (dropView?.heightAnchor.constraint(equalToConstant: 0))!
        }
    }
    
    /*
        @didMoveToWindow
        Set the data source when the button is added to the window as opposed to before.
     */
    public override func didMoveToWindow(){
        self.dropView?.dataSource = self.dataSource
        self.dropView?.backgroundColor = self.dropDownColor
        self.dropView?.textColor = self.dropDownTextColor
        self.dropView?.textSize = self.dropDownTextSize
    }

    //----------------------------
    //----------------------------
    // MARK: helper functions
    //----------------------------
    //----------------------------
    
    //  @touchesBegan
    /// Show or dismiss the drop down menu when clicked
    ///
    /// - Returns: nothing
    public override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        //Guard statement to reduce runtime
        guard !dataSource.isEmpty else { return; }
        
        //Check if the view will go out of bounds
        self.dropView?.layer.cornerRadius = self.dropDownCornerRadius!
        if(self.frame.origin.y < heightOfDropDown){
        
            dropView?.topAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
            self.isOutOfBounds = true
            
            //Change the corner radius to the bottom of the view
            self.dropView?.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
        }
        else{
            //Not overflow
            dropView?.bottomAnchor.constraint(equalTo: self.topAnchor).isActive = true
            self.isOutOfBounds = false
            
            //Change the corner radius to the top of the view
            self.dropView?.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        }
        
        if isOpen == false && !dataSource.isEmpty{
            //Deactivate the constant
            NSLayoutConstraint.deactivate([self.height])
            
            //Adjust the height of the drop down depending on the size of the table contents
            if (self.dropView?.tableView.contentSize.height)! > heightOfDropDown{
                self.height.constant = heightOfDropDown
            }
            else{
                self.height.constant = (self.dropView?.tableView.contentSize.height)!
            }
            
            //Reactivate it again
            NSLayoutConstraint.activate([self.height])
            
            //Animate the click
            UIView.animate(withDuration: showMenuAnimationSpeed, delay: showMenuAnimationDelay, usingSpringWithDamping: showMenuAnimationUsingSpringWithDamping, initialSpringVelocity: showMenuAnimationInitialSpringVelocity, options: .curveEaseInOut, animations: {
                
                self.dropView?.center.y += self.isOutOfBounds ? (self.dropView?.frame.height)! / 2 : 0
                self.dropView?.layoutIfNeeded()
                
            }, completion: nil)
            
            //Update isOpen
            isOpen = true
            
            //Round the bottom corners after 0.5 seconds
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.isOutOfBounds ? self.topCornersOnly() : self.bottomCornersOnly()
            }
        }
        else if(isOpen && !dataSource.isEmpty){
            dismissDropDown()
        }
    }
    
    //  @dismissDropDown
    /// Dismiss the drop down with an animation
    ///
    /// - Returns:nothing
    open func dismissDropDown(){
        //Deactivate the constant
        NSLayoutConstraint.deactivate([self.height])
        
        //Reactivate it again
        self.height.constant = 0
        NSLayoutConstraint.activate([self.height])
        
        //Animate the click
        UIView.animate(withDuration: hideMenuAnimationSpeed, delay: hideMenuAnimationDelay, usingSpringWithDamping: hideMenuAnimationUsingSpringWithDamping, initialSpringVelocity: hideMenuAnimationInitialSpringVelocity, options: .curveEaseInOut, animations: {
            
            self.dropView?.center.y += self.isOutOfBounds ? -(self.dropView?.frame.height)! / 2 : (self.dropView?.frame.height)! / 2
            self.dropView?.layoutIfNeeded()
        }, completion: nil)
        
        //Update isOpen
        isOpen = false
        
        //Round all the corners after 0.5 seconds
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            UIView.animate(withDuration: 0.1) {
                self.allCornersOnly()
            }
        }
    }
    
    //  @dropDownClicked
    /// Change the title and dismiss the drop down when the delegate is completed
    ///
    /// - Parameters:
    ///     - string: the string to change the text of the button to.
    /// - Returns:nothing
    fileprivate func dropDownClicked(string: String){
        dismissDropDown()
        self.setTitle(string, for: .normal)
    }
}

//----------------------------
//----------------------------
// MARK: drop down view
//----------------------------
//----------------------------

class DropDownMenu: UIView, UITableViewDelegate, UITableViewDataSource{

    // MARK: asset initialization
    
    open var dataSource: [String] = [String]()                                  //Data to be presented in drop down
    open var textColor: UIColor?                                                //Color of the text
    open var tableView = UITableView()                                          //Table to present the data
    open var textSize: CGFloat? = 18                                            //Size of the text
    fileprivate weak var InternalDelegate: dropDownProtocol?                    //Protocol to change the text of the button. For internal use only
    weak var delegate: dropDownIndexPath?                                       //Protocol to feed another view controller the indexPath clicked
    
    //----------------------------
    //----------------------------
    // MARK: init
    //----------------------------
    //----------------------------
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        //Set up the view
        tableView.backgroundColor = .clear
        
        //Set up the table
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "datacell")
        tableView.separatorStyle = .none
        tableView.layer.cornerRadius = 12
        tableView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        tableView.showsVerticalScrollIndicator = false
        
        self.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        tableView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //----------------------------
    //----------------------------
    // MARK: table functions
    //----------------------------
    //----------------------------
    
    /*
        @numberOfRowsInSection
        Returns the number of cells in the table
     */
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    /*
        @cellForRowAt
        Returns a cell to display
     */
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "datacell", for: indexPath)
        
        //Customize the cell
        cell.textLabel?.text = dataSource[indexPath.row]
        cell.textLabel?.textColor = self.textColor
        cell.textLabel?.font = UIFont.systemFont(ofSize: textSize!)
        cell.textLabel?.adjustsFontSizeToFitWidth = true
        cell.textLabel?.minimumScaleFactor = 0.5
        cell.backgroundColor = .clear//UIColor(red: 62/255, green: 165/255, blue: 176/255, alpha: 1)
        cell.selectionStyle = .none
        
        return cell
    }
    
    //----------------------------
    //----------------------------
    // MARK: helper functions
    //----------------------------
    //----------------------------
    
    /*
        @didSelectRowAt
        Feed the protocol with the text of whatever is clicked
     */
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.InternalDelegate?.dropDownClicked(string: dataSource[indexPath.row])
        self.delegate?.dropDownClicked(indexPath: indexPath)
    }
}
