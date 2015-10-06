import UIKit

class WalletCell: EditableTableViewCell
{
    // MARK: properties
    
    let infoLabel: UILabel = UILabel()
    
    // MARK: inizializers
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        infoLabel.text = "loading ..."
        
        _contentView?.addSubview(infoLabel)
    }
    
    // MARK: layout
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        infoLabel.frame = CGRect(x: _SEPARATOR_OFFSET_, y: 0, width: _contentView!.frame.width , height: _contentView!.frame.height)
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
