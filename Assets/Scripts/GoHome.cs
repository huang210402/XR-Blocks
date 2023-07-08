using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class GoHome : MonoBehaviour
{
    public GameObject menu;
    public GameObject jengaTower;
    public GameObject toyBlock;

    public void Go()
    {
        menu.SetActive(true);
        jengaTower.SetActive(false);
        toyBlock.SetActive(false);
    }
}
