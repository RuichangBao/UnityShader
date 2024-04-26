using UnityEngine;

[ExecuteInEditMode]
public class ProceduralTexture : MonoBehaviour
{
    public Material material;
    
    #region Material properties
    [SerializeField, SetProperty("textureWidth")]
    private int m_textureWidth = 512;
    public int textureWidth
    {
        get { return (m_textureWidth); }
        set { m_textureWidth = value; }
    }
    [SerializeField, SetProperty("±³¾°ÑÕÉ«")]
    private Color m_backgroundColor = Color.white;
    public Color backgroundColor
    {
        get { return (m_backgroundColor); }
        set { m_backgroundColor = value; }
    }
    [SerializeField, SetProperty("circleColor")]
    private Color m_circleColor  = Color.yellow;
    public Color circleColor
    {
        get { return (m_circleColor); }
        set { m_circleColor = value; }
    }
    [SerializeField, SetProperty("blurFactor")]
    private float m_blurFactor =2f;
    public float blurFactor
    {
        get { return (m_blurFactor); }
        set { m_blurFactor = value; }
    }
    #endregion

    private Texture2D m_generatedTexture = null;
    private void Start()
    {
        if (material == null)
        {
            Renderer renderer = GetComponent<Renderer>();
            material = renderer.sharedMaterial;
        }
        _UpdateMaterial();
    }
    private void _UpdateMaterial()
    {
        if (material == null)
            return;
        m_generatedTexture = _GenerateProceduralTexture();
        material.SetTexture("_MainTex",m_generatedTexture);
    }
    private Color _MixColor(Color color0, Color color1, float mixFactor)
    {
        Color mixColor = Color.white;
        mixColor.r = Mathf.Lerp(color0.r, color1.r, mixFactor);
        mixColor.g = Mathf.Lerp(color0.g, color1.g, mixFactor);
        mixColor.b = Mathf.Lerp(color0.b, color1.b, mixFactor);
        mixColor.a = Mathf.Lerp(color0.a, color1.a, mixFactor);
        return mixColor;
    }
    private Texture2D _GenerateProceduralTexture()
    {
        Texture2D proceduralTexture = new Texture2D(textureWidth,textureWidth);
        float circleInterval = textureWidth / 4;
        float radius = textureWidth / 10;
        float edgeBlur = 1 / blurFactor;
        for (int w = 0; w < textureWidth; w++)
        {
            for (int h = 0; h < textureWidth; h++)
            {
                Color pixed = backgroundColor;
                for (int i = 0; i < 3; i++)
                {
                    for (int j = 0; j < 3; j++)
                    {
                        Vector2 circleCenter = new Vector2(circleInterval * (i + 1), circleInterval * (j + 1));
                        float dist = Vector2.Distance(new Vector2(w, h), circleCenter) - radius;

                        Color color = _MixColor(circleColor, new Color(pixed.r, pixed.g, pixed.b, 0), Mathf.SmoothStep(0, 1, dist * edgeBlur));
                        pixed = _MixColor(pixed, color, color.a);
                    }
                }
                proceduralTexture.SetPixel(w, h, pixed);    
            }
        }
        proceduralTexture.Apply();
        return proceduralTexture;
    }
}