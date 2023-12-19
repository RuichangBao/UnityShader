using UnityEngine;
using UnityEngine.UI;

public class TestDefined : MonoBehaviour
{
    public Material material;
    public Button btnRed, btnGreen;
    void Start()
    {
        btnRed.onClick.AddListener(BtnRedOnClick);
        btnGreen.onClick.AddListener(BtnGreenOnClick);
    }

    private void BtnGreenOnClick()
    {
        material.EnableKeyword("GREEN");
        material.DisableKeyword("RED");
    }

    private void BtnRedOnClick()
    {
        material.EnableKeyword("RED");
        material.DisableKeyword("GREEN");
    }
}
