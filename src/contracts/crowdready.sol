//החוזה החכם
//SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

contract crowdready {
    address public owner; //כתובת הארנק של מי שיצר את הפרויקט
    uint public projectTax; // עמלה על הפרויקט אם הפרויקט צלח -הכסף מגיע מהתורמים
    uint public projectCount;  //כמות הפרויקטים 
    uint public balance; // כמות הכסף שיש מכל התורמים
    statsStruct public stats; // סטטיסטיקות על  האתר
    projectStruct[] projects; // מערך של כל הפרויקטים 

    mapping(address => projectStruct[]) projectsOf; //עבור כל ארנק של משתמש נוכל לדעת איזה פרויקטים הוא יצר 
    mapping(uint => backerStruct[]) backersOf; // עבור כל פרויקט נוכל לדעת את כל התורמים שלו
    mapping(uint => bool) public projectExist; // מחזיר כן או לא אם הפרויקט קיים לפי האיידי שלו

    //כל הסטטוסים האפשריים של פרויקט
    enum statusEnum {
        OPEN,
        APPROVED,
        REVERTED,
        DELETED,
        PAIDOUT
    }
    //הגדרת המבנה של הסטטיסטיקה
    struct statsStruct {
        uint totalProjects; //כמות הפרויקטים
        uint totalBacking; // כמות תורמים 
        uint totalDonations;// סהכ סכום שנתרם
    }
    //הגדרת המבנה של כל התורמים , עבור כל תורם יהיו
    struct backerStruct {
        address owner; //כתובת הארנק שלו
        uint contribution; // סך התרומות שהוא תרם לפרויקט
        uint timestamp; // מתי הוא תרם
        bool refunded; // האם התורם קיבל כסף חזרה מהפרויקט או לא 
    }

    //המידע שיהיה על כל פרויקט
    struct projectStruct {
        uint id; //מזהה פרויקט חח"ע
        address owner; //כתובת הארנק של מי שיצר אותו
        string title; //כותרת הפרויקט
        string description; // תיאור הפרויקט
        string imageURL; // כתובת התמונה 
        uint cost; //כמות היעד (כסף)
        uint raised; //כמות שנאספה
        uint timestamp; //הזמן בו נוצר
        uint expiresAt; //תאריך היעד לסיום
        uint backers; //כמות התורמים 
        statusEnum status; //סטטוס הפרויקט 
    }

    // יצירת מודיפייר עבור יוצר הפלטפורמה בלבד(לא יוצר הפרויקט)
    modifier ownerOnly(){
        require(msg.sender == owner, "Owner reserved only");
        _;
    }

    //הגדרת אירוע- נקבל את הפרטים איידי, סוג האירוע, מי מבצע את האירוע, מתי התרחש האירוע
    event Action (
        uint256 id,
        string actionType,
        address indexed executor,
        uint256 timestamp
    );
    //והוא מגדיר את העמלה  ownerהגדרה שמי שיצר את הפרויקט הוא ה-
    constructor(uint _projectTax) {
        owner = msg.sender;
        projectTax = _projectTax;
    }

    //פונקציה ליצירת פרויקט חדש 

    function createProject(
        //הפונקציה תקבל את כל הפרטים הבאים 
        string memory title,
        string memory description,
        string memory imageURL,
        uint cost,
        uint expiresAt
    ) public returns (bool) {
        //הפונקציה תבדוק שאף אחד משדות החובה לא ריק
        require(bytes(title).length > 0, "Title cannot be empty");
        require(bytes(description).length > 0, "Description cannot be empty");
        require(bytes(imageURL).length > 0, "ImageURL cannot be empty");
        require(cost > 0 ether, "Cost cannot be zero");
        //אם כל השדות מולאו בהצלחה
        //נאכלס את כל התכונות של הפרויקט בפרטים שקיבלנו מהמשתמש 
        projectStruct memory project;
        project.id = projectCount;
        project.owner = msg.sender;
        project.title = title;
        project.description = description;
        project.imageURL = imageURL;
        project.cost = cost;
        project.timestamp = block.timestamp;
        project.expiresAt = expiresAt;
        //נוסיף את הפרויקט אל מערך הפרויקטים
        projects.push(project);
        //נוסיף את הפרויקט למאפינג שמצביע על כך שהוא קיים 
        projectExist[projectCount] = true;
        //נוסיף עבור המשתמש שיצר את הפרויקט את הפרויקט הזה במאפינג
        projectsOf[msg.sender].push(project);
        //נעדכן את הסטטיסטיקה של כמות פרויקטים באחד
        stats.totalProjects += 1;

        //ניצור אירוע שבו 
        emit Action (
            projectCount++,     //נעלה את מונה הפרויקטים ב-1 
            "PROJECT CREATED", //סוג האירוע יהיה יצירת פרויקט
            msg.sender, //מבצע הפעולה יוגדר 
            block.timestamp //הזמן בו נוצר הפרויקט יוגדר
        );
        return true; //לבסוף הפונקציה תחזיר ערך בוליאני של טרו
    }


//פונקציה לעדכון פרויקט קיים
    function updateProject(
        //הפונקציה תקבל את הפרטים הבאים
        uint id,
        string memory title,
        string memory description,
        string memory imageURL,
        uint expiresAt
    ) public returns (bool) {
        // הפונקציה תבדוק שמי שמנסה לעדכן פרטים הינו יוצר הפרויקט בלבד ושהפרויקט בכלל כבר קיים
        require(msg.sender == projects[id].owner, "Unauthorized Entity");
        //בדיקה שהשדות לא ריקים
        require(bytes(title).length > 0, "Title cannot be empty");
        require(bytes(description).length > 0, "Description cannot be empty");
        require(bytes(imageURL).length > 0, "ImageURL cannot be empty");

        //אם התנאים בסדר, נגדיר את מה שהמשתמש רוצה מחדש
        projects[id].title = title;
        projects[id].description = description;
        projects[id].imageURL = imageURL;
        projects[id].expiresAt = expiresAt;

        //ניצור אירוע שבו מעדכנים פרויקט
        emit Action (
            id,
            "PROJECT UPDATED",
            msg.sender,
            block.timestamp
        );

        return true; //לבסוף נחזיר טרו
    }

    //פונקציה למחיקת פרויקט
    function deleteProject(uint id) public returns (bool) {
        //הפונקציה תוודא שהפרויקט עדיין פתוח
        require(projects[id].status == statusEnum.OPEN, "Project no longer opened");
        //הפונקציה תבדוק שמי שרוצה למחוק את הפרויקט הוא יוצר הפרויקט בלבד
        require(msg.sender == projects[id].owner, "Unauthorized Entity");

        //נשנה את הסטטוס של הפרויקט לנמחק
        projects[id].status = statusEnum.DELETED;
        //נפעיל את הפונקציה החזרת כסף לפרויקט הנל
        performRefund(id);

        //ניצור אירוע שבו הפרויקט נמחק
        emit Action (
            id,
            "PROJECT DELETED",
            msg.sender,
            block.timestamp
        );

        return true;
    }

//פונקציית החזר כספי לפרויקט 
    function performRefund(uint id) internal {
        //לולאה שעוברת על כל התורמים
        for(uint i = 0; i < backersOf[id].length; i++) {
            //נשמור את כתובת התורם הנוכחי וכמה הוא תרם
            address _owner = backersOf[id][i].owner;
            uint _contribution = backersOf[id][i].contribution;
            
            //נשנה את הסטטוס של התכונה "קיבל החזר כספי" של התורם ל-כן
            backersOf[id][i].refunded = true;
            //נשמור את הזמן שבו זה בוצע
            backersOf[id][i].timestamp = block.timestamp;
            //נפעיל את הפוקנציה שבה ההחזר מבתצע ונשלח אליה את הארנק של התורם והסכום שצריך להחזיר
            payTo(_owner, _contribution);

            //נוריד את מספר התורמים ב-1
            stats.totalBacking -= 1;
            //נוריד את סך התרומות בתרומה של התורם שהוחזרה
            stats.totalDonations -= _contribution;
        }
    }

    //פונקציה לתמיכה בפרויקט 
    function backProject(uint id) public payable returns (bool) {
        //הפונקציה תבדוק את התנאים הבאים 
        require(msg.value > 0 ether, "Ether must be greater than zero");
        require(projectExist[id], "Project not found");
        require(projects[id].status == statusEnum.OPEN, "Project no longer opened");
        //כמות התורמים עולה ב-1
        stats.totalBacking += 1;
        //סך התרומות עולה בכמות התרומה
        stats.totalDonations += msg.value;
        //התכונה של כמות הכסף שנאסף עד כה עולה בכמות התרומה
        projects[id].raised += msg.value;
        //התכונה של כמות התורמים עולה ב-1 
        projects[id].backers += 1;

        //נשמור את פרטי התורם במאפינג של התורמים במקום של הפרויקט הנוכחי אליו תרם
        backersOf[id].push(
            backerStruct(
                msg.sender,
                msg.value,
                block.timestamp,
                false // לא קיבל החזר
            )
        );

        //ניצור אירוע של תמיכה בפרויקט
        emit Action (
            id,
            "PROJECT BACKED",
            msg.sender,
            block.timestamp
        );

        // האם כמות הכסף שנאספה עד כה גדולה מהיעד שהוגדר
        if(projects[id].raised >= projects[id].cost) {
            // אם כן - נשנה את הסטטוס של הפרויקט למאושר
            projects[id].status = statusEnum.APPROVED;
            //נוסיף אל המאזן הכללי של האתר את הסכום שנאסף בפרויקט הנך
            balance += projects[id].raised;
            //נפעיל את הפונקציה למשיכת הכסף מהפרויקט
            performPayout(id);
            return true;
        }
        //אם הזמן הנוכחי גדול או שווה לתוקף האחרון שלה פרויקט - משמע הפרויקט נגמר והיעד לא נאסף
        if(block.timestamp >= projects[id].expiresAt) {
            //  הסטטוס של הפרויקט יהפוך  ל-הוחזר 
            projects[id].status = statusEnum.REVERTED;
            //ונבצע החזר לתורמים
            performRefund(id);
            return true;
        }

        return true;
    }


    // פונקציית משיכת הכסף מפרויקט שאושר (הגיע ליעד)
    function performPayout(uint id) internal {
        //נמשוך למשתנה רייסד את כמות הכסף שנאספה בפרויקט
        uint raised = projects[id].raised;
        //העמלה של הפרויקט
        uint tax = (raised * projectTax) / 100;

        //נעדכן את הסטטוס הפרויקט ל-נמשך הכסף
        projects[id].status = statusEnum.PAIDOUT;

        // נבצע תשלום ליוצר הפרויקט על סך הכמות שנאספה פחות העמלה
        payTo(projects[id].owner, (raised - tax));
        //נבצע תשלום לפלטפורמה (לאתר)של העמלה
        payTo(owner, tax);

        //נוסיף למאזמן של האתר את הכסף שנאסף
        balance -= projects[id].raised;
        // ניצור אירוע של משיכת כסף
        emit Action (
            id,
            "PROJECT PAID OUT",
            msg.sender,
            block.timestamp
        );
    }

    // פונקציה לבקשת החזר כסף 
    function requestRefund(uint id) public returns (bool) {
        require(
            //הפונקציה מוודא שהפרויקט לא נמחק כבר או נדחה כבר (כי אז הוא כבר היה מקבל החזר אוטומטית)
            projects[id].status != statusEnum.REVERTED ||
            projects[id].status != statusEnum.DELETED,
            "Project not marked as revert or delete"
        );
        //הסטטוס של הפרויקט משתנה ל- הוחזר כסף
        projects[id].status = statusEnum.REVERTED;
        //מפעילים את הפונקציה להחזרת הכסף
        performRefund(id);
        return true;
    }

    //פונקציה שדרכה יוצר הפרויקט יכול לבקש משיכת הכסף של הפרויקט
    function payOutProject(uint id) public returns (bool) {
        //הפונקציה מוודא שהסטטוס של הפרויקט הוא מאושר (כלומר שהסכום כסף הושג)
        require(projects[id].status == statusEnum.APPROVED, "Project not APPROVED");
        // הפונקציה מוודא שמי שמבקש למשוך כסף הוא יוצר הפרויקט או יוצר הפלטפורמה עצמה
        require(
            msg.sender == projects[id].owner ||
            msg.sender == owner,
            "Unauthorized Entity"
        );
        //הפעלת הפונקציה לביצוע משיכת הכסף
        performPayout(id);
        return true;
    }

    //פונקציה לשינוי ערך העמלה שהוגדר - יכולה להתבצע רק על ידי יוצר הפטפורמה
    function changeTax(uint _taxPct) public ownerOnly {
        projectTax = _taxPct;
    }

    //קבלת הפרטים של פרויקט מסוים 
    function getProject(uint id) public view returns (projectStruct memory) {
        //הפונקציה מוודא שהפרויקט קיים 
        require(projectExist[id], "Project not found");
        //מחזירה אותו מתוך מערך הפרויקטים 
        return projects[id];
    }
    
    //פונקציה לקבלת מערך כל הפרויקטים 
    function getProjects() public view returns (projectStruct[] memory) {
        return projects;
    }
    
    //פונקציה לקבלת כלל התורמים של פרויקט מסוים 
    function getBackers(uint id) public view returns (backerStruct[] memory) {
        return backersOf[id];
    }

    //הפונקצייה שדרכה מתבצע התשלום. הפונקציה מקבלת למי לשלוח ואיזה סכום ומבצעת העברה
    function payTo(address to, uint256 amount) internal {
        (bool success, ) = payable(to).call{value: amount}("");
        require(success);
    }
}



// crowdready.createProject("Project Title", "Project Description", 1000, 10, 100, "https://example.com/project-image.jpg", {from: accounts[0], value: web3.utils.toWei("1", "ether")})
