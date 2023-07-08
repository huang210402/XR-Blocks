using System.Collections;
using System.Collections.Generic;
using UnityEditor;
using UnityEngine;

public class GoToGame : MonoBehaviour
{
    public GameSelect gs;

    public GameObject menu;
    public GameObject jengaTower;
    public GameObject toyBlock;

    public void Go()
    {
        if(gs.gameSelect == 2)
        {
            menu.SetActive(false);
            jengaTower.SetActive(true);
            toyBlock.SetActive(false);
        }

        if (gs.gameSelect == 3)
        {
            menu.SetActive(false);
            jengaTower.SetActive(false);
            toyBlock.SetActive(true);
        }
    }
}
