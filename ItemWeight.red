public class ItemWeights {
                
                public static func ClothesWeight() -> Float = 0.45;
                public static func CyberwearWeight() -> Float = 0.25;
                public static func AmmoWeight() -> Float = 0.03;
                public static func EdibleWeight() -> Float = 0.3;
                public static func JunkWeight() -> Float = 0.75;
                public static func PartWeight() -> Float = 0.6;
                public static func GrenadeWeight() -> Float = 0.6;
                public static func MaterialsWeight() -> Float = 0.2; 
                public static func ShowMaterialsUnderProgramsFilter() -> Bool = true;
                
                
                public static func SetText(text: inkTextRef, weight: Float) -> Void{
                                inkTextRef.SetText(text, FloatToStringPrec(weight, 2));
                }
                
                public static func SetText(text: inkTextRef, itemData: ref<gameItemData>) -> Void{
                                inkTextRef.SetText(text, FloatToStringPrec(ItemWeights.GetItemWeight(itemData), 3));
                }
                
                public final static func GetItemStackWeight(itemData: ref<gameItemData>) -> Float {
                                return ItemWeights.GetItemWeight(itemData) * Cast<Float>(itemData.GetQuantity());
                }
                
                public final static func GetItemWeight(itemData: ref<gameItemData>) -> Float {
                                let weight : Float = 0.00;
                                let itemType: gamedataItemType = itemData.GetItemType();                   
                                
                                if !IsDefined(itemData){
                                                return weight;
                                }
                                
                                if Equals(itemType, gamedataItemType.Invalid){
                                                return weight;
                                }
                                if IsDefined(itemData) {
                                                weight = itemData.GetStatValueByType(gamedataStatType.Weight);
                                };
                                if (weight == 0.00)
                                {                               
                                                switch itemType {
                                                                case gamedataItemType.Clo_Face:
                                                                case gamedataItemType.Clo_Feet:
                                                                case gamedataItemType.Clo_Head:
                                                                case gamedataItemType.Clo_InnerChest:
                                                                case gamedataItemType.Clo_Legs:
                                                                case gamedataItemType.Clo_OuterChest:
                                                                case gamedataItemType.Clo_Outfit:
                                                                                return ItemWeights.ClothesWeight();
                                                                                
                                                                case gamedataItemType.Con_Ammo:
                                                                                return ItemWeights.AmmoWeight();
                                                                
                                                                case gamedataItemType.Con_Edible:
                                                                case gamedataItemType.Con_Inhaler:
                                                                case gamedataItemType.Con_Injector:
                                                                case gamedataItemType.Con_LongLasting:
                                                                                return ItemWeights.EdibleWeight();
                                                                
                                                                // case gamedataItemType.Cyb_Ability:
                                                                // case gamedataItemType.Cyb_Launcher:
                                                                // case gamedataItemType.Cyb_MantisBlades:
                                                                // case gamedataItemType.Cyb_NanoWires:
                                                                // case gamedataItemType.Cyb_StrongArms:
                                                                                // return ItemWeights.CyberwearWeight();
                                                                                
                                                                case gamedataItemType.Gen_CraftingMaterial: // Can't be dropped, only stashed or sold.
                                                                                return ItemWeights.MaterialsWeight();
                                                                // case gamedataItemType.Gen_DataBank:
                                                                // case gamedataItemType.Gen_Keycard:
                                                                // case gamedataItemType.Gen_Misc:
                                                                // case gamedataItemType.Gen_Readable:
                                                                case gamedataItemType.Gen_Junk:
                                                                case gamedataItemType.Gen_Jewellery:
                                                                                  return ItemWeights.JunkWeight();
                                                                
                                                                case gamedataItemType.Prt_Capacitor:
                                                                case gamedataItemType.Prt_Fragment:
                                                                case gamedataItemType.Prt_Magazine:
                                                                case gamedataItemType.Prt_Mod:
                                                                case gamedataItemType.Prt_Muzzle:                                                  
                                                                // case gamedataItemType.Prt_Program: // Buggy behaviour when equipping & unequipping.
                                                                case gamedataItemType.Prt_Receiver:
                                                                case gamedataItemType.Prt_Scope:
                                                                case gamedataItemType.Prt_ScopeRail:
                                                                case gamedataItemType.Prt_Stock:
                                                                case gamedataItemType.Prt_FabricEnhancer:
                                                                case gamedataItemType.Prt_HeadFabricEnhancer:
                                                                case gamedataItemType.Prt_FaceFabricEnhancer:
                                                                case gamedataItemType.Prt_OuterTorsoFabricEnhancer:
                                                                case gamedataItemType.Prt_TorsoFabricEnhancer:
                                                                case gamedataItemType.Prt_PantsFabricEnhancer:
                                                                case gamedataItemType.Prt_BootsFabricEnhancer:
                                                                case gamedataItemType.Prt_HandgunMuzzle:
                                                                case gamedataItemType.Prt_RifleMuzzle:
                                                                case gamedataItemType.Prt_TargetingSystem:
                                                                                return ItemWeights.PartWeight();
                                                                                                                                                                
                                                                // case gamedataItemType.Fla_Launcher
                                                                // case gamedataItemType.Fla_Rifle:
                                                                // case gamedataItemType.Fla_Shock:
                                                                // case gamedataItemType.Fla_Support
                                                                case gamedataItemType.GrenadeDelivery:
                                                                case gamedataItemType.Grenade_Core:
                                                                case gamedataItemType.Gad_Grenade:
                                                                                return ItemWeights.GrenadeWeight();
                                                }
                                }
                                return weight;
                }
}


// Adds ammo and materials to the items list.  
@wrapMethod(InventoryDataManagerV2)
public final static func GetItemTypesForSorting() -> array<gamedataItemType> {
    let areas: array<gamedataItemType> = wrappedMethod();
    ArrayPush(areas, gamedataItemType.Con_Ammo);
                if (ItemWeights.ShowMaterialsUnderProgramsFilter()) {
                                ArrayPush(areas, gamedataItemType.Gen_CraftingMaterial);
                }
    return areas;
}


// Adds ammo to display on the weapons filter.
// Adds materials to display on the filter.
@wrapMethod(ItemCategoryFliter)
  public final static func IsOfCategoryType(filter: ItemFilterCategory data: wref<gameItemData>) -> Bool {
                let itemType: gamedataItemType = data.GetItemType();             
    if !IsDefined(data) {
                                return false;
    };
    switch filter {
                                case ItemFilterCategory.RangedWeapons:
                                                return data.HasTag(WeaponObject.GetRangedWeaponTag()) || data.HasTag(n"Ammo");
                                case ItemFilterCategory.Programs:                      
                                                if (ItemWeights.ShowMaterialsUnderProgramsFilter()) {
                                                                return data.HasTag(n"SoftwareShard") || data.HasTag(n"CraftingPart");
                                                }
                                                else {
                                                                return data.HasTag(n"SoftwareShard");
                                                }
    };
    return wrappedMethod(filter, data);
}

// ??
@wrapMethod(InventoryDataManagerV2)
public final func EquipmentAreaToItemTypes(area: gamedataEquipmentArea) -> array<gamedataItemType> {
    let result: array<gamedataItemType> = wrappedMethod(area);
                switch area {   
                                case gamedataEquipmentArea.Weapon:
                                                ArrayPush(result, gamedataItemType.Con_Ammo);
                };             
    return result;
}

// ??
@wrapMethod(InventoryDataManagerV2)
  public final static func GetInventoryWeaponTypes() -> array<gamedataItemType> {    
    let areas: array<gamedataItemType> = wrappedMethod();
    ArrayPush(areas, gamedataItemType.Con_Ammo);
    return areas;
}

// Determines the default sort position in inventory?
@wrapMethod(ItemCompareBuilder)
  private final static func GetItemTypeIndex(itemType: gamedataItemType) -> Int32 {
                
    switch itemType {
                                case gamedataItemType.Con_Ammo:
                                                return 20;
    };
    wrappedMethod(itemType);
}

// Not sure what this affects.
@replaceMethod(RPGManager)
public final static func GetItemWeight(itemData: ref<gameItemData>) -> Float {
                return ItemWeights.GetItemWeight(itemData);
}

// Updates the weight counter when transferring items.
@replaceMethod(ItemQuantityPickerController)
protected final func UpdateWeight() -> Void {
                let weight: Float = this.m_itemWeight * Cast<Float>(this.m_choosenQuantity);
                inkTextRef.SetText(this.m_weightText, FloatToStringPrec(weight, 2));
}

// Updates the weight counter when transferring items.
@wrapMethod(ItemQuantityPickerController)
private final func SetData() -> Void {
                wrappedMethod();
                this.m_itemWeight = ItemWeights.GetItemWeight(InventoryItemData.GetGameItemData(this.m_gameData));
                this.UpdateWeight();
}

// Updates the weight for cyberdeck item tooltips?
@replaceMethod(CyberdeckTooltip)
protected final func UpdateWeight() -> Void {
                ItemWeights.SetText(this.m_itemWeightText, InventoryItemData.GetGameItemData(this.m_data.inventoryItemData));
}

// Updates the weight for some tooltips?
@wrapMethod(ItemTooltipController)
protected final func UpdateWeight() -> Void {
                wrappedMethod();
                // Note: Mislabeled field.
                ItemWeights.SetText(this.m_requireLevelText, InventoryItemData.GetGameItemData(this.m_data.inventoryItemData));
}

// Inventory/Backpack/Vendor tooltip.
@wrapMethod(MinimalItemTooltipData)
public final static func FromInventoryTooltipData(tooltipData: ref<InventoryTooltipData>) -> ref<MinimalItemTooltipData> {
                let result: ref<MinimalItemTooltipData> = wrappedMethod(tooltipData);
                result.weight = ItemWeights.GetItemStackWeight(result.itemData);
                return result;
}

// Updates the weight for some tooltips?
@wrapMethod(ItemTooltipBottomModule)
public func Update(data: ref<MinimalItemTooltipData>) -> Void {
                wrappedMethod(data);
                ItemWeights.SetText(this.m_weightText, data.weight);
}

// Updates the weight for looting tooltips.
@wrapMethod(LootingController)
private final func GetTooltipMinimalData(lootingOwner: wref<GameObject>) -> ref<MinimalItemTooltipData> {
                let data: ref<MinimalItemTooltipData> = wrappedMethod(lootingOwner);
                data.weight = ItemWeights.GetItemStackWeight(data.itemData);
                return data;
}


// Updates the drop mechanism to use the non-zero weights.
@replaceMethod(MenuHubGameController)
protected cb func OnDropQueueUpdatedEvent(evt: ref<DropQueueUpdatedEvent>) -> Bool {
    let item: ref<gameItemData>;
    let result: Float;
    let dropQueue: array<ItemModParams> = evt.m_dropQueue;
    let i: Int32 = 0;
    while i < ArraySize(dropQueue) {
                                item = GameInstance.GetTransactionSystem(this.m_player.GetGame()).GetItemData(this.m_player, dropQueue[i].itemID);
                                result += ItemWeights.GetItemWeight(item) * Cast<Float>(dropQueue[i].quantity);
                                i += 1;
    };
    this.HandlePlayerWeightUpdated(result);
}
  
 // Updates sorting by weight to use the non-zero weights.
@wrapMethod(ItemCompareBuilder)
public final static func BuildInventoryItemSortData(item: InventoryItemData uiScriptableSystem: ref<UIScriptableSystem>) -> InventoryItemSortData {
                let sortData : InventoryItemSortData = wrappedMethod(item, uiScriptableSystem);
                sortData.Weight = ItemWeights.GetItemWeight(InventoryItemData.GetGameItemData(item));
    return sortData;
}
